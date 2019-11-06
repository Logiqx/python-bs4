# python-bs4

Official Python image with Beautiful Soup 4 and lxml installed for Alpine Linux.

The pip installation of lxml requires g++ and the development libraries libxml2-dev + libxslt-dev. After the pip installation all of the build dependencies are removed from the image, leaving just the run-time libraries libxml2 and libxslt. The result is a lightweight image of Python and Beautiful Soup 4.

### Usage

Note: This image is not meant to be run directly since it does not include things such as a non-privileged user. It is really intended for use within builds of runtime containers for Python scripts.

The example Dockerfile converts a collection of Jupyter notebooks to regular Python scripts, building a lightweight runtime image. The employment of a multistage build ensures that the final image is kept nice and small.

```
# Base image versions
ARG NOTEBOOK_VERSION=latest
ARG PYTHON_VERSION=3.8
ARG ALPINE_VERSION=3.10

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
RUN addgroup -g ${PY_GID} -S ${PY_GROUP} && \
    adduser -u ${PY_UID} -S ${PY_USER} -G ${PY_USER} && \
    mkdir -p /home/${PY_USER}/work && \
    chown ${PY_USER} /home/${PY_USER}/work

# Copy project files from the builder
USER ${PY_USER}
WORKDIR /home/${PY_USER}/work
COPY --from=builder --chown=jovyan:jovyan /home/jovyan/work/ ./

# Define the command / entrypoint
CMD ["python3"]
```

Note: This example was derived from the [Dockerfile](https://github.com/Logiqx/wca-db/blob/master/Dockerfile) in my [wca-db](https://github.com/Logiqx/wca-db) project on GitHub.

### Building a Custom Image

To build a custom image for a specific version of the Python or Alpine use the following syntax:

```
docker image build --build-arg PYTHON_VERSION=3.8 . -t python-bs4:3.8-alpine3.10
```

You can provide overrides for the following:

- PYTHON_VERSION - default of 3.8
- ALPINE_VERSION - default of 3.10

Note: Building lxml requires >1GB memory and does not work on tiny machines such as the t3.micro on AWS. To avoid the machine grinding to a standstill the build must be run on a larger instance type such as t3.small.
