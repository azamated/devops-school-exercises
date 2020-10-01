FROM java:8-alpine
RUN mkdir /home/webapp
WORKDIR /home/webapp/
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git && cd boxfuse-sample-java-war-hello/ && mvn package;
RUN cp boxfuse-sample-java-war-hello/target/hello-1.0.war /home/webapp/hello-1.0.war


