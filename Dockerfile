#------------------------------------------------------------------------------
#
# Python3 & scrapy
#
# cf.
# - https://scrapy.org/
#
#------------------------------------------------------------------------------

FROM python:3-alpine

RUN apk add build-base openssl-dev libxml2-dev libxslt-dev libffi-dev
RUN pip install scrapy

COPY ./src /src/

ENTRYPOINT ["sh", "/src/entrypoint.sh"]

