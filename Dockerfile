# pull official base image
FROM python:3.7

# set work directory
WORKDIR /usr/src/myproject

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# copy project
COPY ./src/myproject /usr/src/myproject

# install dependencies
RUN pip install --upgrade pip setuptools
RUN pip install -r /usr/src/myproject/requirements.txt

# prepare nginx
#RUN rm -f /etc/nginx/conf.d/default.conf
#COPY ./config/nginx.conf /etc/nginx/conf.d
