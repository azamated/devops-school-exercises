FROM tomcat
WORKDIR /home/webapp
#ADD /var/lib/docker/volumes/docker-compose_war_depl_appdata/_data/hello-1.0.war /usr/local/tomcat/webapps/hello-1.0.war
RUN cp ./hello-1.0.war /tmp
EXPOSE 8080