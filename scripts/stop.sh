#!/usr/bin/env bash

SCRIPT_DIR="$(dirname $0)"

env=$1
shift

function usage {
  cat << EOL

start.sh environment [options...]

    environment   The environment (e.g., "dev") to build.

    options...    Additional options to be passed to the
                  docker-compose down command

EOL
}

if [ "$env" == "--help" ]; then
    usage
    exit 0
fi

if [[ "$env" == "example" ]]; then
    echo "A valid environment must be given."
    usage
    exit 1
fi

$SCRIPT_DIR/run.sh "$env" down $*
