# pull official base image
FROM python:3.8

# accept arguments
ARG PIP_REQUIREMENTS=production.txt

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip install --upgrade pip setuptools

RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib

# create user for the Django project
RUN useradd -ms /bin/bash myproject

# set current user
USER myproject

# set work directory
WORKDIR /home/myproject

# copy and  install pip requirements
COPY --chown=myproject ./src/myproject/requirements /home/myproject/requirements/
RUN pip install -r /home/myproject/requirements/${PIP_REQUIREMENTS}

# copy Django project files
COPY --chown=myproject ./src/myproject /home/myproject/
