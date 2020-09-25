FROM ruby:2.7-buster

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /workspace

RUN apt update && apt install -y --no-install-recommends git build-essential redis-tools
RUN echo "alias redis-cli='redis-cli -h redis'" > /root/.bashrc

CMD ["sleep", "infinity"]
