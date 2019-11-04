ARG PYTHON_VERSION=3.8
ARG ALPINE_VERSION=3.10

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

RUN apk add --no-cache libxml2 libxslt && \
    apk add --no-cache --virtual .build-deps libxml2-dev libxslt-dev g++ && \
    pip install --no-cache-dir beautifulsoup4 lxml && \
    apk del .build-deps
