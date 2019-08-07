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

scrapy runspider /src/test.py


exit 0
