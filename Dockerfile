FROM ruby:2.7-alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
# https://stackoverflow.com/a/42145848/13110561
RUN apk update && apk add git build-base && bundle install && apk del --purge build-base
COPY . .

CMD ["./main.rb"]
