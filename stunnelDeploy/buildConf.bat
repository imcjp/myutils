@echo off
: confBuilder.py has been deployed to the pipy project cjptools
set YAML_FILE=%~1
echo %YAML_FILE%
if "%YAML_FILE%"=="" (
    echo Please provide a YAML file path.
    exit /b 1
)
python -c "from cjptools import confBuilder; confBuilder.build(r'C:\Program Files (x86)\stunnel\config\cConf.yaml')" > stunnel.conf

if %errorlevel% neq 0 (
    echo Failed to build configuration.
    exit /b 1
) else (
    echo Configuration successfully written to stunnel.conf
    type stunnel.conf
    pause
)

exit /b 0