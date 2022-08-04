FROM ruby:3-alpine

COPY Gemfile Gemfile.lock
RUN bundle install

COPY . .
