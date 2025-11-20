Param(
  [ValidateSet("questa","vcs","xrun")][string]$tool = "questa",
  [string]$test = "gpu_base_test",
  [string]$seed = "random",
  [ValidateSet("UVM_NONE","UVM_LOW","UVM_MEDIUM","UVM_HIGH","UVM_FULL")][string]$uvm_verb = "UVM_MEDIUM",
  [switch]$waves,
  [switch]$cov,
  [switch]$gui,
  [string]$outdir = "out",
  [string]$extra = ""
)

$ErrorActionPreference = "Stop"
if (!(Test-Path $outdir)) { New-Item -ItemType Directory -Path $outdir | Out-Null }

$filelist = "scripts/filelist.f"
$plusargs = "+UVM_TESTNAME=$test +UVM_VERBOSITY=$uvm_verb"
if ($seed -ne "random") { $plusargs = "$plusargs +ntb_random_seed=$seed" }
if ($waves) { $plusargs = "$plusargs +VCD=1 +GPU_DBG=1" } else { $plusargs = "$plusargs +GPU_DBG=1" }
if ($extra -ne "") { $plusargs = "$plusargs $extra" }

if ($tool -eq "questa") {
    $covOpt = ""
    if ($cov.IsPresent) { $covOpt = "-coverage all" }
    $work = Join-Path $outdir "work"
    if (!(Test-Path $work)) { & vlib $work }
    & vmap work $work | Out-Null
    & vlog -work $work -sv -timescale "1ns/1ps" +acc -mfcu -f $filelist | Tee-Object -FilePath (Join-Path $outdir "compile.log")

    $cmdArgs = @()
    if (-not $gui.IsPresent) { $cmdArgs += "-c" }
    $cmdArgs += @("-classdebug", "-assertdebug")
    if ($covOpt -ne "") { $cmdArgs += $covOpt }
    $cmdArgs += @("work.tb_top")
    $cmdArgs += $plusargs.split(" ")

    $doCmd = ""
    if ($waves) { $doCmd += "log -r /*; " }
    $doCmd += "run -all; quit -f"
    $cmdArgs += @("-do", "`"$doCmd`"")

    $logFile = Join-Path $outdir "questa_sim.log"
    if ($gui) {
      & vsim @cmdArgs
    } else {
      & vsim @cmdArgs | Tee-Object -FilePath $logFile
    }
}
elseif ($tool -eq "vcs") {
    $covOpt = ""
    if ($cov.IsPresent) { $covOpt = "-cm line+cond+fsm+tgl+branch" }
    & vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm -debug_access+all $covOpt -f $filelist -o "$outdir/simv"
    $vpdOpt = ""
    if ($waves.IsPresent) { $vpdOpt = "+vpdfile+$outdir/waves.vpd -cm_name simv" }
    Push-Location $outdir
    .\simv $plusargs $vpdOpt | Tee-Object -FilePath "sim.log"
    Pop-Location
}
elseif ($tool -eq "xrun") {
    $covOpt = ""
    if ($cov.IsPresent) { $covOpt = "-coverage all" }
    $guiOpt = ""
    if ($gui.IsPresent) { $guiOpt = "-gui" }
    $wavesOpt = ""
    if ($waves.IsPresent) { $wavesOpt = "-access +rwc" }
    & xrun -64bit -sv -uvm -timescale 1ns/1ps -f $filelist $covOpt $guiOpt $wavesOpt +define+XRUN $plusargs | Tee-Object -FilePath (Join-Path $outdir "xrun.log")
}

Write-Host "Simulation completed. Outputs in $outdir"


