FROM ruby:alpine
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN bundle install
