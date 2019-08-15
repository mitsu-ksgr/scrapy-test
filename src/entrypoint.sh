#!/bin/bash

#------------------------------------------------------------------------------
#
# entrypoint.sh
#
# this script takes agrs from `docker run` command and
# passes them to scrapy.
#
#------------------------------------------------------------------------------

main() {
    local result=0
    scrapy $@ || result=$?

    if [ ! "${result}" = "0" ]; then
        echo "Error: failed to runspider." 1>&2
        exit 1
    fi

    echo "Succeeded!"
}

main $@
exit 0

