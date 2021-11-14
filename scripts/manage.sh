#!/usr/bin/env bash

SCRIPT_DIR="$(dirname $0)"

env=$1
shift

function usage {
  cat << EOL

manage.sh environment [options...]

    environment   The environment (e.g., "dev") to build.

    command...    Command and options to be passed to the
                  Django management system (manage.py)

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

$SCRIPT_DIR/run.sh "$env" exec gunicorn python manage.py $*
