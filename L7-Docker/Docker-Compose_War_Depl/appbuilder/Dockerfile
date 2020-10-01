FROM ringcentral/maven
ADD ../boxfuse-sample-java-war-hello /home/webapp
RUN cd ../boxfuse-sample-java-war-hello && mvn package
RUN cp ../boxfuse-sample-java-war-hello/target/hello-1.0.war /home/webapp/hello-1.0.war


