FROM ringcentral/maven
RUN mkdir /home/webapp
ADD ./boxfuse-sample-java-war-hello /home/webapp/
RUN cd /home/webapp/boxfuse-sample-java-war-hello/
RUN mvn package && cp ./target/hello-1.0.war /home/webapp/hello-1.0.war


