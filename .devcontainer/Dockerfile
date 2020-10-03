FROM ruby:2.7-buster

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends git build-essential redis-tools openssh-client
RUN echo "alias redis-cli='redis-cli -h redis'" > /root/.bashrc

CMD ["sleep", "infinity"]
