param([ValidateRange(1,2048)][int]$SizeMB = 500)
$ErrorActionPreference = 'Stop'
# Creates a separate demo file; never overwrites the submitted source log.
$path = Join-Path $PSScriptRoot '..\data\log-large-demo.log'
$stream = [System.IO.File]::Open($path, [System.IO.FileMode]::CreateNew)
try {
    $writer = New-Object System.IO.StreamWriter($stream, ([System.Text.Encoding]::ASCII))
    $writer.AutoFlush = $false
    $target = [long]$SizeMB * 1000000
    $bytes = 0L
    $i = 0
    while ($bytes -lt $target) {
        $level = if ($i % 1000 -eq 0) { 'ERROR 404' } else { 'INFO' }
        $line = '2026-10-29 08:00:00 TRAM001 ' + $level + ' sensor heartbeat payload=0123456789'
        $remaining = $target - $bytes
        if ($remaining -le $line.Length + 2) {
            $writer.Write(('X' * [int]$remaining))
            $bytes += $remaining
        } else {
            $writer.Write($line + "`r`n")
            $bytes += $line.Length + 2
        }
        $i++
    }
    $writer.Flush()
} finally {
    if ($null -ne $writer) { $writer.Dispose() } else { $stream.Dispose() }
}
Write-Output "Created $SizeMB MB decimal demo log at $path"
