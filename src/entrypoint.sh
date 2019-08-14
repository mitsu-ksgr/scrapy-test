#!/bin/bash

#------------------------------------------------------------------------------
#
# entrypoint.sh
#
# this script takes agrs from `docker run` command and
# passes them to python script.
#
#------------------------------------------------------------------------------

#python /src/test.py $@

#
# Flags
#
OPT_FLAG_START_PROJECT=
OPT_FLAG_HELP=


#
# Parse args
#
parse_args() {
    while getopts hs flag; do
        case "${flag}" in
            h ) # show scrapy help
                OPT_FLAG_HELP='true'
                ;;
            s ) # Start Project
                OPT_FLAG_START_PROJECT='true'
                ;;
            * )
                exit 0
                ;;
        esac
    done
}

err() {
    echo "Error: $@" 1>&2
    exit 1
}

show_help() {
    local cmd=$1

    if [ -n "${cmd}" ]; then
        scrapy ${cmd} -h
    else
        scrapy -h
    fi
}

start_project() {
    local project_name=$1
    if [ -z "${project_name}" ]; then
        err "please specify a project name"
    fi

    local project_path="/out/${project_name}"
    scrapy startproject ${project_name} ${project_path}
}

main() {
    parse_args $@
    shift $(expr $OPTIND - 1)

    if [ -n "${OPT_FLAG_HELP}" ]; then
        show_help $@
        exit 0
    fi

    if [ -n "${OPT_FLAG_START_PROJECT}" ]; then
        start_project $@
        exit 0
    fi

    local source_path='/src/test.py' #TODO: args
    local output_file_path='/out/out.json'
    local result=0
    scrapy runspider \
        --output=${output_file_path} \
        --output-format=json \
        --loglevel=WARN \
        ${source_path} \
        || result=$?

    if [ ! "${result}" = "0" ]; then
        err "failed to runspider."
    fi

    echo "Succeeded! output: ${output_file_path}"
    exit 0
}

main $@
exit 0

