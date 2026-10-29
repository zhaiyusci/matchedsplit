$ErrorActionPreference = 'Stop'
$previousTexmfVar = $env:TEXMFVAR
$previousTexmfCache = $env:TEXMFCACHE
Push-Location $PSScriptRoot
try {
    New-Item -ItemType Directory -Path build -Force | Out-Null
    $env:TEXMFVAR = Join-Path $PSScriptRoot 'build/texmf-var'
    $env:TEXMFCACHE = $env:TEXMFVAR
    New-Item -ItemType Directory -Path $env:TEXMFVAR -Force | Out-Null
    foreach ($engine in @('pdflatex', 'xelatex', 'lualatex')) {
        foreach ($case in @('demo', 'nested_test', 'regression', 'assertions', 'default_split_test', 'override_test', 'override_tbtags_test', 'override_left_test', 'numbered_test', 'numbered_override_test', 'numbered_left_test', 'audit_features', 'rainbow_test', 'rainbow_local_test', 'rainbow_assertions')) {
            $job = "$engine-$case"
            $passes = if ($case -like 'numbered*') { 2 } else { 1 }
            foreach ($pass in 1..$passes) {
            $process = Start-Process -FilePath (Get-Command $engine).Source -ArgumentList @('-interaction=nonstopmode', '-halt-on-error', '-output-directory=build', "-jobname=$job", "$case.tex") -WindowStyle Hidden -PassThru -RedirectStandardOutput "build/$job.stdout.txt" -RedirectStandardError "build/$job.stderr.txt"
            if (-not $process.WaitForExit(30000)) {
                $process.Kill()
                throw "$job exceeded 30 seconds"
            }
            if ($process.ExitCode -ne 0) { throw "$job failed; see build/$job.log" }
            }
            if ($case -eq 'assertions' -and -not (Select-String -Path "build/$job.log" -Pattern 'ASSERTIONS PASSED' -Quiet)) { throw "$job missing assertions" }
            if ($case -like 'override*') {
                $aux = Get-Content "build/$job.aux" -Raw
                foreach ($label in @(@('one', '1'), @('two', '2'), @('four', '4'))) {
                    if (-not $aux.Contains('\newlabel{eq:' + $label[0] + '}{{' + $label[1] + '}')) { throw "$job incorrect equation label" }
                }
            }
            if ($case -like 'numbered*') {
                $aux = Get-Content "build/$job.aux" -Raw
                foreach ($label in @(@('first','1'), @('second','2'), @('third','3'), @('fourth','4'), @('fifth','5'), @('custom','{A}'), @('bare','B'), @('sixth','6'), @('seventh','7'))) {
                    if (-not $aux.Contains('\newlabel{row:' + $label[0] + '}{{' + $label[1] + '}')) { throw "$job incorrect row label: $($label[0])" }
                }
                if (Select-String -Path "build/$job.log" -Pattern 'undefined references|multiply defined|Overfull' -Quiet) { throw "$job reference or layout warning" }
            }
            if ($case -eq 'audit_features') {
                $aux = Get-Content "build/$job.aux" -Raw
                foreach ($label in @(@('first','1'), @('last','3'), @('split','8'))) {
                    if (-not $aux.Contains('\newlabel{audit:' + $label[0] + '}{{' + $label[1] + '}')) { throw "$job incorrect audit label" }
                }
            }
            Write-Output "PASS $job"
        }
    }
    $badCases = @{
        'right' = '\right)'
        'middle' = '\middle|x'
        'left' = '\left(x'
        'delimiter' = '\left'
        'label-argument' = '\label'
        'tag-argument' = '\tag'
        'tag-star-argument' = '\tag*'
        'intertext-argument' = '\intertext'
        'row-spacing' = 'x &= a\\[3pt'
    }
    foreach ($case in $badCases.Keys) {
        $job = "invalid-$case"
        $body = '\documentclass{article}\usepackage{matchedsplit}\begin{document}\[\begin{matchedsplit}' + $badCases[$case] + '\end{matchedsplit}\]\end{document}'
        Set-Content "build/$job.tex" -Value $body -Encoding ascii
        $process = Start-Process -FilePath (Get-Command pdflatex).Source -ArgumentList @('-interaction=nonstopmode', '-halt-on-error', '-output-directory=build', "-jobname=$job", "build/$job.tex") -WindowStyle Hidden -PassThru -RedirectStandardOutput "build/$job.stdout.txt" -RedirectStandardError "build/$job.stderr.txt"
        if (-not $process.WaitForExit(30000)) { $process.Kill(); throw "$job timed out" }
        if ($process.ExitCode -eq 0 -or -not (Select-String -Path "build/$job.log" -Pattern 'Package matchedsplit Error' -Quiet)) { throw "$job did not report the expected error" }
        Write-Output "PASS $job (expected error)"
    }
$optionFailures = @{
 'empty-package-colors' = '\documentclass{article}\usepackage[colors={}]{matchedsplit}\begin{document}x\end{document}'
 'empty-local-colors' = '\documentclass{article}\usepackage{matchedsplit}\begin{document}\begin{matchedalign}[rainbow,colors={}]x&=y\end{matchedalign}\end{document}'
 'invalid-rainbow-value' = '\documentclass{article}\usepackage{matchedsplit}\begin{document}\begin{matchedalign}[rainbow=invalid]x&=y\end{matchedalign}\end{document}'
}
foreach ($case in $optionFailures.Keys) {
 $job = "invalid-$case"
 Set-Content "build/$job.tex" $optionFailures[$case] -Encoding ascii
 $process = Start-Process -FilePath (Get-Command pdflatex).Source -ArgumentList @('-interaction=nonstopmode','-halt-on-error','-output-directory=build',"-jobname=$job","build/$job.tex") -WindowStyle Hidden -PassThru -RedirectStandardOutput "build/$job.stdout.txt" -RedirectStandardError "build/$job.stderr.txt"
 if (-not $process.WaitForExit(30000)) { $process.Kill(); throw "$job timed out" }
 if ($process.ExitCode -eq 0 -or -not (Select-String "build/$job.log" -Pattern 'Package (matchedsplit|keys) Error|LaTeX Error: Key.*matchedsplit/environment/rainbow' -Quiet)) { throw "$job did not reject invalid options" }
 Write-Output "PASS $job (expected error)"
}


} finally {
    $env:TEXMFVAR = $previousTexmfVar
    $env:TEXMFCACHE = $previousTexmfCache
    Pop-Location
}






