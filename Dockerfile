FROM python:3.8-slim-buster as base

# Install pipenv and compilation dependencies
RUN pip3 install -U pipenv
RUN apt-get update && apt-get install -y --no-install-recommends gcc

ADD . /rds
WORKDIR /rds
COPY Pipfile Pipfile.lock ./
RUN pipenv install --system

# Install application into container
COPY . .

# Server
EXPOSE 8080
STOPSIGNAL SIGINT
