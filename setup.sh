#!/bin/bash
#Creat a Docker Network for Jenkins
echo -e "Creating Network For Jenkins:"
docker network create jenkins
echo -e "\n"

#Build Custom Docker Image for Jenkins.
echo -e "Building Image:"
docker build -t jenkins-blueocean .
echo -e "\n"

#Run the Build Image.
echo -e "Running Image:"
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  jenkins-blueocean
echo -e "\n"

echo -e "Setting Up..."
sleep 20
echo -e "\n"

#Done.
echo -e "Jenkins Running on: http://localhost:8080"
echo -e "\n"
echo -e "Admin Password:"
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
echo -e "\n"
echo "Press any key to continue..."
read -n 1 -s

