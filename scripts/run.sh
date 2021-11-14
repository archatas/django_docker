#!/usr/bin/env bash
env="$1"
shift

function usage {
  cat << EOL

run.sh environment command...

    environment   The environment (e.g., "dev") to run against.

    command...    The docker-compose command to execute
                  (i.e., "up -d")

EOL
}

if [ "$env" == "--help" ]; then
    usage
    exit 0
fi

env_file="./config/.env-$env"

if [[ "$env" == "example" || ! -f "$env_file" ]]; then
    echo "A valid environment must be given."
    usage
    exit 1
fi

docker-compose --env-file="$env_file" $*
