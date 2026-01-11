FROM jenkins/jenkins:lts-jdk17

USER root

# Avoid mirrors (some networks can't resolve mirrors.updates.jenkins.io)
ENV JENKINS_UC=https://updates.jenkins.io
ENV JENKINS_UC_DOWNLOAD=https://updates.jenkins.io/download

# Docker CLI (so pipelines can run `docker ...` / `docker compose ...`)
RUN apt-get update \
  && apt-get install -y --no-install-recommends docker.io docker-compose-plugin ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

USER jenkins

