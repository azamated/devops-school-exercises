FROM alpine:3.6
RUN apk update && apk add openjdk8 && apk add wget && mkdir /usr/local/tomcat
WORKDIR /tmp
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz
RUN tar xvzf apache-tomcat-9.0.38.tar.gz
RUN cp -Rv apache-tomcat-9.0.38/* /usr/local/tomcat/ && rm -rf apache-tomcat-9.0.38 && rm apache-tomcat-9.0.38.tar.gz
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]