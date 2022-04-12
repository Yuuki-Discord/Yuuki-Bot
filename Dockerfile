ARG RUBY_VERSION=3.1.2

FROM ruby:${RUBY_VERSION}-alpine as builder

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN apk add --no-cache git build-base
RUN bundle config path vendor/bundle && bundle install


##########
# RUNNER #
##########
FROM ruby:${RUBY_VERSION}-alpine

WORKDIR /usr/src/app

# Ensure git is installed
RUN apk add --no-cache git

# Copy vendor cache over from builder
RUN bundle config path vendor/bundle
COPY --from=builder /usr/src/app/vendor ./vendor
COPY . .

CMD ["./main.rb"]
