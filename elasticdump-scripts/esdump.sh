#!/bin/bash

ES_HOST="localhost"
ES_PORT="9242"
DUMP_DIR="./dumps"


function backup () {
    local -r idx_name="$1"
    local -r in="http://${ES_HOST}:${ES_PORT}/${idx_name}"

    elasticdump \
        --input="$in" \
        --output="${DUMP_DIR}/${idx_name}_mapping.json" \
        --type=mapping

    elasticdump \
        --type=data \
        --input="$in" \
        --output=$ \
        | gzip > "${DUMP_DIR}/${idx_name}.json.gz"
}

function print_usage () {
    echo "usage: $0 <index-name>"
}

function main () {
    ## Arg parsing
    ##
    if [ -z ${1+x} ] || [[ ${1} = *"help"* ]]
    then
        print_usage
        exit 1
    fi

    backup "$1"
}

main "${@}"
