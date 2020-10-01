FROM maven
RUN mkdir /home/webapp
ADD boxfuse-sample-java-war-hello /home/webapp
WORKDIR /home/webapp/boxfuse-sample-java-war-hello
RUN mvn package
WORKDIR /home/webapp/boxfuse-sample-java-war-hello/target
RUN cp ./hello-1.0.war /home/webapp/hello-1.0.war



