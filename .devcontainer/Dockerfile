FROM ruby:2.7-alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /workspace

RUN apk update && apk add git build-base redis bash
RUN echo "alias redis-cli='redis-cli -h redis'" > /root/.bashrc

CMD ["sleep", "infinity"]
