FROM ksimple/java8-mvn-nodejs-npm-python3
RUN mkdir /home/webapp
ADD boxfuse-sample-java-war-hello /home/webapp
WORKDIR /home/webapp/boxfuse-sample-java-war-hello
RUN mvn package && cp ./target/hello-1.0.war /home/webapp/hello-1.0.war



