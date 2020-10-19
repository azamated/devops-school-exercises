- Dockerfile - "builder" node based on Ubuntu and Maven
- Dockerfile_prod - production image based in tomcat
- Jenkins - Java war app pipeline

- Builder images needs to be build in advance using Dockerfile and pushed to the docker registry
Refer to the commands file for additional info

- A private key file needs to be copied to the Dockerfile context directory in advance.
cp /root/.ssh/id_rsa .

