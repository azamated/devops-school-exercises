
Task: Using Ansible build two instances in AWS. Once instance should build the project and pack a war artifact into a docker image.
Another instance shall run a docker conteiner with the image built in the first instance.

-  Prerequisites:
 |__ Ansible 2.9
 |__ Python
 |__ Pyhton-pip
 |__ Boto
 |__ Boto3
 |__ awscli
 
 
1. Install prerequisites
2. Configure awscli
3. Configure AWS access key and secret jey amd make sure awscli works
4. Define variables: ami and region
5. Generate a key pair on AWS and transfer it into the local machine
6. The first instance provisions maven, builds a war artifact and builds a docker image.
7. The second instance pulls the docker image from aws ecr and runs the image.

-- ~/.aws directory needs to be synchronised with all aws instances, this is required for authentication with AWS registry

--  When Ansible ssh to the instances fro the first time, it asks for configuration, need to manually enter "yes"
 

 
 
 
