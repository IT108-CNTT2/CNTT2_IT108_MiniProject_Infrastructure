@echo off
setlocal
rem Run from the parent of greentech-system. Existing files are preserved.
for %%D in (greentech-system greentech-system\docs greentech-system\scripts greentech-system\data greentech-system\backup) do if not exist "%%D" mkdir "%%D"
if not exist "greentech-system\data\.env" (echo SYSTEM_KEY=demo_greentech_2026)>"greentech-system\data\.env"
if not exist "greentech-system\data\log-he-thong.log" type nul >"greentech-system\data\log-he-thong.log"
echo Khoi tao xong. Cac tep co san duoc giu nguyen.
endlocal
