@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem AUDIT: only read source logs and write reports; no destructive commands.
pushd "%~dp0" || exit /b 2
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\audit.ps1"
if errorlevel 1 goto audit_failed
if not exist "..\data\log-he-thong.log" goto missing_log
if not exist "..\backup" mkdir "..\backup"
if not exist "..\backup" goto io_failed
set "REPORT=..\backup\bao-cao-su-co.txt"
>>"%REPORT%" echo ============================================================
if errorlevel 1 goto io_failed
>>"%REPORT%" echo BAO CAO SU CO GREENTECH
>>"%REPORT%" echo THOI GIAN: %date% %time%
>>"%REPORT%" echo NGUON: data/log-he-thong.log
>>"%REPORT%" echo ------------------------------------------------------------
rem TYPE and FINDSTR stream the file instead of loading all lines into RAM.
type "..\data\log-he-thong.log" | findstr /I /C:"CRITICAL" /C:"ERROR" >>"%REPORT%"
if errorlevel 2 goto filter_failed
set "COUNT=0"
for /f %%N in ('type "..\data\log-he-thong.log" ^| findstr /I /C:"CRITICAL" /C:"ERROR" ^| find /V /C ""') do set "COUNT=%%N"
>>"%REPORT%" echo TONG SO SU CO: %COUNT%
>>"%REPORT%" echo.
echo Da ghi bao cao. TONG SO SU CO: %COUNT%
popd
exit /b 0
:audit_failed
echo LOI: Audit khong dat. Khong tao bao cao.
popd
exit /b 3
:missing_log
echo LOI: Khong tim thay log-he-thong.log.
popd
exit /b 4
:filter_failed
echo LOI: Khong the loc log. Bao cao co the chua hoan tat.
popd
exit /b 5
:io_failed
echo LOI: Khong the ghi thu muc backup.
popd
exit /b 6
