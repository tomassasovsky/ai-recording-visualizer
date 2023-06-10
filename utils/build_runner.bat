@echo off

set file=encryption_key.json

for /f "tokens=2 delims=: " %%A in ('findstr /i "ENCRYPTION_KEY" %file%') do set "ENCRYPTION_KEY=%%~A"

dart run build_runner build --define dotenv_gen_runner:dotenv_gen=ENCRYPTION_KEY=%ENCRYPTION_KEY% --verbose --delete-conflicting-outputs
