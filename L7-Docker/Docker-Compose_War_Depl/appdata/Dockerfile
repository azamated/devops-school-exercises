FROM ringcentral/maven
RUN mkdir /home/webapp
ADD ./boxfuse-sample-java-war-hello /home/webapp/boxfuse-sample-java-war-hello
WORKDIR /home/webapp/boxfuse-sample-java-war-hello
RUN mvn package
RUN cp target/hello-1.0.war /home/webapp


