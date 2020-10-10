FROM tomcat
RUN apt-get update && apt-get install default-jdk -y && apt-get install maven -y && apt-get install git -y && \
apt-get clean;
RUN mkdir /home/docker
WORKDIR /home/docker/
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git && cd boxfuse-sample-java-war-hello/ && mvn package;
RUN cp boxfuse-sample-java-war-hello/target/hello-1.0.war /usr/local/tomcat/webapps/