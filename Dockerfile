FROM ruby:latest
RUN mkdir /app
ADD . /app
WORKDIR /app

ENV RACK_ENV ${RACK_ENV:-development}

RUN gem install bundler
RUN make setup
