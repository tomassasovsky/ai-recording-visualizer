@echo off

if not exist ".env" mkdir .env
CALL :PullEnvironmentVariables "development"
CALL :PullEnvironmentVariables "production"
EXIT /B %ERRORLEVEL%

:PullEnvironmentVariables
echo Getting for %~1...
CALL npx dotenv-vault pull %~1 .env/.env.%~1