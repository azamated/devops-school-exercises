FROM alpine:latest
RUN apk update && apk add openjdk8 && apk add wget && mkdir /usr/local/tomcat
WORKDIR /tmp
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz
RUN tar xvzf apache-tomcat-9.0.38.tar.gz && cp -Rv cp apache-tomcat-9.0.38.tar.gz/* /usr/local/tomcat/
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]