#!/bin/bash

# Source
SRC_ES_HOST="localhost"
SRC_ES_PORT="9242"

# Desctination
DST_ES_HOST="localhost"
DST_ES_PORT="9202"


function transfer () {
    local -r idx_name="$1"
    local -r in="http://${SRC_ES_HOST}:${SRC_ES_PORT}/${idx_name}"
    local -r out="http://${DST_ES_HOST}:${DST_ES_PORT}/${idx_name}"

    docker run --network="host" --rm -ti taskrabbit/elasticsearch-dump \
        --input="$in" \
        --output="$out" \
        --type=mapping

    docker run --network="host" --rm -ti taskrabbit/elasticsearch-dump \
        --input="$in" \
        --output="$out" \
        --type=data
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

    transfer "$1"
}

main "${@}"

