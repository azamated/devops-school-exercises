FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
# Install pacakges
RUN apt-get update && apt-get docker.io -y
RUN apt-get install -y default-jdk && apt-get install -y maven && apt-get install -y git
