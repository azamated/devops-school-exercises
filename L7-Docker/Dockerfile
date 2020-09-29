FROM ubuntu:14.04
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all 
RUN  apt-get install flask -y && apr-get install \
&& apt-get install Jinja2 -y && apt-get install Werkzeug -y &&  apt-get install distribute -y &&  apt-get install wsgiref -y;
WORKDIR /home/ubuntu/docker/devops-school-exercises/L7-Docker
RUN cp app.py /opt/webapp/
EXPOSE 5000
CMD python app.py

