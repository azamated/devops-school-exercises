FROM ringcentral/maven
RUN mkdir /home/webapp
#ADD ./boxfuse-sample-java-war-hello /home/webapp/boxfuse-sample-java-war-hello
ADD ./boxfuse-sample-java-war-hello /tmp/boxfuse-sample-java-war-hello
WORKDIR /tmp/boxfuse-sample-java-war-hello
#WORKDIR /home/webapp/boxfuse-sample-java-war-hello
RUN mvn package
WORKDIR /tmp/boxfuse-sample-java-war-hello/target
RUN cp ./hello-1.0.war /home/webapp/hello-1.0.war