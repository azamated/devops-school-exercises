FROM ubuntu:14.04
ADD ./app/requirements.txt /tmp/requirements.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all && apt-get install -y -q python-pip
RUN pip install -r /tmp/requirements.txt
ADD ./app /opt/webapp/
EXPOSE 5000
CMD ["python", "/opt/webapp/app.py"]