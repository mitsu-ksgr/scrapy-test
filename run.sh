#!/bin/sh

#------------------------------------------------------------------------------
#
# run.sh
#
#------------------------------------------------------------------------------

readonly DOCKER_IMG='python-scrapy-test:latest'

#
# Flags
#
OPT_FLAG_BUILD_IMAGE=
OPT_FLAG_HELP=


#
# Parse args
#
parse_args() {
    while getopts bh flag; do
        case "${flag}" in
            b ) # build docker image
                OPT_FLAG_BUILD_IMAGE='true'
                ;;
            h )
                OPT_FLAG_HELP='true'
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

show_scrapy_help() {
    docker run --rm -t ${DOCKER_IMG} -h
}

start_project() {
    local project_name="$1"
    local project_path="$2"
    if [ $# -le 2 ]; then
        shift $#
    else
        shift 2
    fi

    if [ "${project_name}" = '-h' ]; then
        docker run --rm -t ${DOCKER_IMG} startproject -h
        return
    fi

    if [ -z "${project_name}" ]; then
        err "startproject command required project name."
    fi

    if [ -n "${project_path}" ]; then
        if [ "${project_path:0:4}" = '/out' ]; then
          : # do nothing.
        elif [ "${project_path:0:1}" = '/' ]; then
            project_path="/out${project_path}"
        else
            project_path="/out/${project_path}"
        fi
    else
        project_path="/out/${project_name}"
    fi

    docker run --rm \
        -v "$(pwd)/out":/out \
        -t ${DOCKER_IMG} \
        startproject "${project_name}" "${project_path}" $@

    sudo chown -R $USER:$USER "$(pwd)${project_path}"
}

runspider() {
    if [ "${1}" = '-h' ]; then
        docker run --rm -t ${DOCKER_IMG} runspider -h
        return
    fi

    # TODO: use args
    local output_path="/out/out.json"
    docker run --rm \
      -v "$(pwd)/out":/out \
      -t ${DOCKER_IMG} \
      runspider \
        --output=${output_path} \
        --output-format=json \
        --loglevel=WARN \
        $@
}

main() {
    parse_args $@
    shift $(expr $OPTIND - 1)

    if [ -n "${OPT_FLAG_BUILD_IMAGE}" ]; then
        docker build -t ${DOCKER_IMG} .
    fi

    if [ -n "${OPT_FLAG_HELP}" ]; then
        show_scrapy_help
        exit 0
    fi

    local cmd="$1"
    local out_path="$(pwd)/out"
    shift

    case "${cmd}" in
        'startproject' )
            start_project $@
            ;;
        'runspider' )
            runspider $@
            ;;
        * )
            docker run --rm \
                -v "${out_path}":/out \
                -t ${DOCKER_IMG} \
                $cmd $@
            ;;
    esac

    sudo chown $USER:$USER ${out_path}/*.*
}

main $@
exit 0

