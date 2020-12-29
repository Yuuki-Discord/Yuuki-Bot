FROM ruby:3.0-alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
# https://stackoverflow.com/a/42145848/13110561
RUN apk add --no-cache git build-base && bundle install && apk del --purge build-base
COPY . .

CMD ["./main.rb"]
