@echo off
Rem Creat a Docker Network for Jenkins.
echo Creating Network For Jenkins:
docker network create jenkins
echo.

Rem Build Custom Docker Image for Jenkins.
echo Building Image:
docker build -t jenkins-blueocean .
echo.

Rem Run the Build Image.
echo Running Image:
docker run --name jenkins-blueocean --restart=on-failure --detach ^
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 ^
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 ^
  --volume jenkins-data:/var/jenkins_home ^
  --volume jenkins-docker-certs:/certs/client:ro ^
  --publish 8080:8080 --publish 50000:50000 jenkins-blueocean
echo.

echo Setting Up...
timeout /t 20 /nobreak > NUL
echo.

Rem Done.
echo Jenkins Running on: http://localhost:8080
echo.
echo Admin Password:
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
echo.
pause