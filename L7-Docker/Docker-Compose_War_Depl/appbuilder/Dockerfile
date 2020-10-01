FROM ringcentral/maven
ADD ../boxfuse-sample-java-war-hello /home/webapp
WORKDIR /home/webapp/boxfuse-sample-java-war-hello
RUN mvn package
RUN cp ./target/hello-1.0.war /home/webapp/hello-1.0.war


