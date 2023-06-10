file=./encryption_key.json

# file is a json file, grab the value of the key ENCRYPTION_KEY
ENCRYPTION_KEY=$(grep -oP '(?<="ENCRYPTION_KEY": ")[^"]*' $file)

dart run build_runner build --define dotenv_gen_runner:dotenv_gen=ENCRYPTION_KEY=$ENCRYPTION_KEY --verbose --delete-conflicting-outputs
