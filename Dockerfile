ARG PYTHON_VERSION=3.10
ARG ALPINE_VERSION=3.15

FROM logiqx/python-lxml:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

RUN pip install --no-cache-dir beautifulsoup4==4.10.*
