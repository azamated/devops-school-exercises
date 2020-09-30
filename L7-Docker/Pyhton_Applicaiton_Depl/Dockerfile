FROM ubuntu:14.04
WORKDIR /home/azamat/devops-school-exercises
RUN cp /L7-Docker/Pyhton_Applicaiton_Depl/app/requirements.txt /tmp/
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all python-pip
RUN pip install -r /tmp/requirements.txt
RUN cp /L7-Docker/Pyhton_Applicaiton_Depl/app/app.py /opt/webapp/
EXPOSE 5000
CMD ["python", "/opt/webapp/app.py"]