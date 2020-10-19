- Dockerfile - "builder" the node is based on Ubuntu and Maven
- Dockerfile_prod - a production image based on tomcat
- Jenkins - Java war app pipeline

- Maven image needs to be build in advance using Dockerfile and pushed to the docker registry. Refer to the commands file for additional info

- A private key file needs to be copied to the Dockerfile context directory in advance.
cp /root/.ssh/id_rsa.

