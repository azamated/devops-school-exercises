FROM ubuntu:14.04
ADD ./L7-Docker/Pyhton_Applicaiton_Depl/app/requirements.txt /tmp/requirements.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all python-pip
RUN pip install -r /tmp/requirements.txt
ADD ./L7-Docker/Pyhton_Applicaiton_Depl/app /opt/webapp/
EXPOSE 5000
CMD ["python", "/opt/webapp/app.py"]