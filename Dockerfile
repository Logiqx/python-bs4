ARG PYTHON_VERSION=3.9
ARG ALPINE_VERSION=3.13

FROM logiqx/python-lxml:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

RUN pip install --no-cache-dir beautifulsoup4==4.9.*
