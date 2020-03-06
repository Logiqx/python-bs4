# python-bs4

Official Python image with Beautiful Soup 4 and lxml installed for Alpine Linux + Debian Slim.

This project is based upon logiqx/python-lxml. The result is a lightweight image of Python and Beautiful Soup 4.

### Usage

Note: This image is not meant to be run directly since it does not include things such as a non-privileged user. It is really intended for use within builds of runtime containers for Python scripts.

The example Dockerfile for Alpine Linux converts a collection of Jupyter notebooks to regular Python scripts, building a lightweight runtime image. The employment of a multistage build ensures that the final image is kept nice and small.

```
# Base image versions
ARG NOTEBOOK_VERSION=latest
ARG PYTHON_VERSION=3.8
ARG ALPINE_VERSION=3.11

# Jupyter notebook image is used as the builder
FROM jupyter/base-notebook:${NOTEBOOK_VERSION} AS builder

# Copy the required project files
WORKDIR /home/jovyan/work/demo
COPY --chown=jovyan:users python/*.*py* ./python/

# Convert Jupyter notebooks to regular Python scripts
RUN jupyter nbconvert --to python python/*.ipynb && \
    rm python/*.ipynb

# Ensure project file permissions are correct
RUN chmod 755 python/*.py

# Create final image from Python 3 + Beautiful Soup 4 on Alpine Linux
FROM logiqx/python-bs4:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

# Note: Jovian is a fictional native inhabitant of the planet Jupiter
ARG PY_USER=jovyan
ARG PY_GROUP=jovyan
ARG PY_UID=1000
ARG PY_GID=1000

# Create the Python user and work directory
RUN addgroup -g ${PY_GID} ${PY_GROUP} && \
    adduser -u ${PY_UID} --disabled-password ${PY_USER} -G ${PY_GROUP} && \
    mkdir -p /home/${PY_USER}/work && \
    chown -R ${PY_USER} /home/${PY_USER}

# Install Tini
RUN apk add --no-cache tini=~0.18

# Copy project files from the builder
USER ${PY_USER}
WORKDIR /home/${PY_USER}/work/demo
COPY --from=builder --chown=jovyan:jovyan /home/jovyan/work/demo/ ./

# Wait for CMD to exit, reap zombies and perform signal forwarding
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["python"]
```

Note: This example was derived from the [Dockerfile](https://github.com/Logiqx/wca-db/blob/master/Dockerfile) in my [wca-db](https://github.com/Logiqx/wca-db) project on GitHub.

### Building a Custom Image

#### Alpine Linux

To build a custom image for a specific version of the Python or Alpine Linux use the following syntax:

```
docker image build --build-arg PYTHON_VERSION=3.8 . -t python-bs4:3.8-alpine3.11
```

You can provide overrides for the following:

- PYTHON_VERSION - default of 3.8
- ALPINE_VERSION - default of 3.11

#### Debian Slim

To build a custom image for a specific version of the Python or Debian Slim use the following syntax:

```
docker image build --build-arg PYTHON_VERSION=3.8 . -f Dockerfile-slim -t python-bs4:3.8-slim-buster
```

You can provide overrides for the following:

- PYTHON_VERSION - default of 3.8
- DEBIAN_VERSION - default of buster
