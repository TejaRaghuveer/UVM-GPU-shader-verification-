Param(
  [ValidateSet("questa","vcs","xrun")][string]$tool = "questa",
  [string]$workdir = ".",
  [string]$outdir = "cov_report"
)

if (!(Test-Path $outdir)) { New-Item -ItemType Directory -Path $outdir | Out-Null }

switch ($tool) {
  "questa" {
    Write-Host "Generating coverage report with Questa (UCDB)..."
    # Merge any UCDB files in workdir
    $ucdbs = Get-ChildItem -Path $workdir -Recurse -Filter *.ucdb | Select-Object -ExpandProperty FullName
    if ($ucdbs.Count -eq 0) {
      Write-Warning "No .ucdb files found in $workdir"
    } else {
      $merged = Join-Path $outdir "merged.ucdb"
      & vcover merge $merged $ucdbs
      & vcover report -html -details -output (Join-Path $outdir "index.html") $merged
    }
  }
  "vcs" {
    Write-Host "Generating coverage report with VCS (URG)..."
    $covdbs = Get-ChildItem -Path $workdir -Recurse -Filter "simv.vdb" | Select-Object -ExpandProperty FullName
    if ($covdbs.Count -eq 0) {
      Write-Warning "No simv.vdb directories found in $workdir"
    } else {
      & urg -dir $covdbs -format both -report $outdir
    }
  }
  "xrun" {
    Write-Host "Generating coverage report with Xcelium (IMC)..."
    $xcdus = Get-ChildItem -Path $workdir -Recurse -Filter "*.xcr" | Select-Object -ExpandProperty FullName
    if ($xcdus.Count -eq 0) {
      Write-Warning "No .xcr coverage snapshots found in $workdir"
    } else {
      $merged = Join-Path $outdir "merged.xdb"
      & imc -exec "db open $merged -create; foreach file {$($xcdus -join ' ')} {db merge $file}; report -html $outdir; exit"
    }
  }
}

Write-Host "Coverage report generation complete. Output at $outdir"


