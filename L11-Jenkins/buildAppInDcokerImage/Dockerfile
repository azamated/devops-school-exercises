FROM openjdk:14.0.2-jdk-buster

RUN apt-get update

RUN mkdir -p /root/.ssh
RUN  echo "    IdentityFile /root/.ssh/id_rsa" >> /etc/ssh/ssh_config
VOLUME [ "/root/.ssh" ]

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get apt-get install -y maven && apt-get install -y git && apt-get install -y wget
# Install docker-ce (official way)
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io
