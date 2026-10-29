$ErrorActionPreference = 'Stop'
# Local static audit of executable batch lines before auto_report.bat runs.
# This check is educational; it is not a sandbox for untrusted software.
$target = Join-Path $PSScriptRoot 'auto_report.bat'
$patterns = @(
    '(?i)(^|[&|()\s])(?:del|erase|rd|rmdir|format|diskpart|shutdown)(?=\s|$)',
    '(?i)Remove-Item|Invoke-Expression|EncodedCommand|DownloadString|\biex\b',
    '(?i)\brm\s+[^\r\n]*(?:-rf|-fr)|\b(?:curl|wget)\b'
)
$lines = Get-Content -LiteralPath $target
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i].Trim()
    if ($line -match '^(?i:@?rem\b|::)' -or $line -eq '') { continue }
    foreach ($pattern in $patterns) {
        if ($line -match $pattern) {
            Write-Output ("AUDIT FAILED: line {0}" -f ($i + 1))
            exit 1
        }
    }
}
Write-Output 'AUDIT PASSED: no blocked command detected.'
exit 0
