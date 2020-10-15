FROM ubuntu:latest
# Install pacakges
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y default-jdk && apt-get install -y maven && apt-get install -y git && apt-get install -y wget
# Install docker
RUN apt-get -y install docker-ce
