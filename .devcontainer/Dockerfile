FROM ruby:3.0-buster
WORKDIR /workspace

# This Dockerfile contains a lot of "hacky" things, but since it's used for development and not production 
#  I assume it's fine.

RUN apt-get update && apt-get install -y --no-install-recommends git build-essential redis-tools openssh-client sudo

# For ease of use, convenience more than anything.
RUN echo "alias redis-cli='redis-cli -h redis'" > /root/.bashrc

# For the sake of a pretty prompt, default theme is fine enough.
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Yay, more scripts from the internet!
RUN bash -c "$(curl -fsSL https://krypt.co/kr)"

# Stolen from Microsofts image
ADD https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/containers/docker-in-docker/.devcontainer/library-scripts/docker-in-docker-debian.sh  /tmp/library-scripts/
# Use opensource Docker Engine
ARG USE_MOBY="true"
# Install guest Docker
RUN /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "false" "root" "${USE_MOBY}"

# Run the guest Docker daemon
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]-
