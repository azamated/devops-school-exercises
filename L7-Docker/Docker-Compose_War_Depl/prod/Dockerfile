FROM alpine
RUN apk update && apk add openjdk8 && apk add wget && mkdir /usr/local/tomcat
WORKDIR /tmp
#RUN wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz
RUN wget https://downloads.apache.org/tomcat/tomcat-7/v7.0.106/bin/apache-tomcat-7.0.106.tar.gz
RUN tar xvzf apache-tomcat-7.0.106.tar.gz
RUN cp -Rv apache-tomcat-7.0.106/* /usr/local/tomcat/ && rm -rf apache-tomcat-7.0.106 && rm apache-tomcat-7.0.106.tar.gz
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]