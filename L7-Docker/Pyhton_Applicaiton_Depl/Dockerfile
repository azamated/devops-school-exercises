FROM ubuntu:14.04
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-all python-pip
ADD ./app/requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip
RUN pip install -qr /tmp/requirements.txt
ADD ./app /opt/webapp/
EXPOSE 5000
CMD ["python", "/opt/webapp/app.py"]