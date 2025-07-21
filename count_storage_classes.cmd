@echo off
setlocal enabledelayedexpansion

set BUCKET=jijo-archive
set "PREFIX=9 illustrations/"

REM Counters
set /a STANDARD=0
set /a GLACIER=0
set /a DEEP_ARCHIVE=0
set /a INTELLIGENT_TIERING=0
set /a ONEZONE_IA=0
set /a STANDARD_IA=0
set /a REDUCED_REDUNDANCY=0
set /a UNKNOWN=0
set /a TOTAL=0

REM Get object list
aws s3api list-objects-v2 --bucket "%BUCKET%" --prefix="%PREFIX%" --output json > objects.json

REM Loop through StorageClass lines
for /f "tokens=*" %%L in ('type objects.json ^| findstr /i "\"StorageClass\""') do (
    set "LINE=%%L"

    REM Remove prefix
    set "SC=!LINE:*\"StorageClass\": \"=!"

    REM Remove trailing quote and comma
    for %%C in (!SC!) do (
        set "SC=%%C"
        set "SC=!SC:"=!"
        set "SC=!SC:,=!"
    )

    set /a TOTAL+=1

    if /i "!SC!"=="STANDARD" set /a STANDARD+=1
    if /i "!SC!"=="GLACIER" set /a GLACIER+=1
    if /i "!SC!"=="DEEP_ARCHIVE" set /a DEEP_ARCHIVE+=1
    if /i "!SC!"=="INTELLIGENT_TIERING" set /a INTELLIGENT_TIERING+=1
    if /i "!SC!"=="ONEZONE_IA" set /a ONEZONE_IA+=1
    if /i "!SC!"=="STANDARD_IA" set /a STANDARD_IA+=1
    if /i "!SC!"=="REDUCED_REDUNDANCY" set /a REDUCED_REDUNDANCY+=1

    if not "!SC!"=="STANDARD" if not "!SC!"=="GLACIER" if not "!SC!"=="DEEP_ARCHIVE" if not "!SC!"=="INTELLIGENT_TIERING" if not "!SC!"=="ONEZONE_IA" if not "!SC!"=="STANDARD_IA" if not "!SC!"=="REDUCED_REDUNDANCY" (
        set /a UNKNOWN+=1
    )
)

echo ----------------------------------------
echo Total files scanned           : %TOTAL%
echo STANDARD                      : %STANDARD%
echo GLACIER                       : %GLACIER%
echo DEEP_ARCHIVE                  : %DEEP_ARCHIVE%
echo INTELLIGENT_TIERING           : %INTELLIGENT_TIERING%
echo ONEZONE_IA                    : %ONEZONE_IA%
echo STANDARD_IA                   : %STANDARD_IA%
echo REDUCED_REDUNDANCY            : %REDUCED_REDUNDANCY%
echo UNKNOWN / UNCLASSIFIED        : %UNKNOWN%
echo ----------------------------------------

del objects.json >nul 2>&1
endlocal
