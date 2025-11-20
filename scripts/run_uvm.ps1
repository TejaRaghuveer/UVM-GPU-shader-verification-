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

switch ($tool) {
  "questa" {
    $covOpt = $cov.IsPresent ? "-coverage all" : ""
    $work = Join-Path $outdir "work"
    if (!(Test-Path $work)) { & vlib $work }
    & vlog -work $work -sv -timescale "1ns/1ps" +acc -mfcu -f $filelist
    $doScript = Join-Path $outdir "run.do"
    $logFile = Join-Path $outdir "transcript.log"
    $waveDo = if ($waves) { "add wave -r /*" } else { "" }
    $runCmd = if ($gui) { "vsim -classdebug -assertdebug $covOpt work.tb_top $plusargs" } else { "vsim -c -classdebug -assertdebug $covOpt work.tb_top $plusargs -do ""run -all; quit -f""" }
    if ($gui) {
      & vsim -do $doScript | Out-Null
    } else {
      & vsim -c -do "vlog -work $work -sv -mfcu -f $filelist; vsim $covOpt work.tb_top $plusargs; $waveDo; run -all; quit -f" | Tee-Object -FilePath $logFile
    }
  }
  "vcs" {
    $covOpt = $cov.IsPresent ? "-cm line+cond+fsm+tgl+branch" : ""
    & vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm -debug_access+all $covOpt -f $filelist -o "$outdir/simv"
    $vpdOpt = $waves.IsPresent ? "+vpdfile+$outdir/waves.vpd -cm_name simv" : ""
    Push-Location $outdir
    .\simv $plusargs $vpdOpt | Tee-Object -FilePath "sim.log"
    Pop-Location
  }
  "xrun" {
    $covOpt = $cov.IsPresent ? "-coverage all" : ""
    $guiOpt = $gui.IsPresent ? "-gui" : ""
    $wavesOpt = $waves.IsPresent ? "-access +rwc" : ""
    & xrun -64bit -sv -uvm -timescale 1ns/1ps -f $filelist $covOpt $guiOpt $wavesOpt +define+XRUN $plusargs | Tee-Object -FilePath (Join-Path $outdir "xrun.log")
  }
}

Write-Host "Simulation completed. Outputs in $outdir"


