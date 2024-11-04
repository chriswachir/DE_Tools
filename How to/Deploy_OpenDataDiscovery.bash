 
 #https://docs.opendatadiscovery.org/configuration-and-deployment/enable-security/authentication/oauth2-oidc
 # https://github.com/opendatadiscovery/odd-platform/blob/main/docker/demo.yaml
 
 #Install Docker

 --Install Docker
sudo yum install -y docker
sudo service docker start
sudo chkconfig docker on  # activates docker service auto-start on reboot
sudo usermod -a -G docker $USER # Adds current user to docker group
 
sudo adduser openDataDiscovery
sudo touch /var/log/openDataDiscovery.log
sudo chown adm:adm /var/log/openDataDiscovery.log
sudo touch /etc/default/openDataDiscovery
sudo usermod -a -G docker openDataDiscovery
sudo mkdir /data/
sudo mkdir /data/openDataDiscovery
sudo chown openDataDiscovery:openDataDiscovery /data/openDataDiscovery 
nano /etc/passwd  #change openDataDiscovery user home dir to /data/openDataDiscovery  

sudo yum install -y git
# sudo reboot

 # install docker compose for user openDataDiscovery
su - openDataDiscovery # switch to openDataDiscovery user or sudo su - openDataDiscovery
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}

#ensure that you don’t have any other PostgreSQL instance using port 5432
lsof -i -P -n | grep LISTEN | grep 5432

# If there is kill then run the lsof command again
 kill -9 <PID> 

#Clone github repo
git clone https://github.com/opendatadiscovery/odd-platform.git

# Change port to map to 8080
nano docker/demo.yaml  #change 8080 t0 8081:8080
nano docker/docker-compose.yaml 
# Use the Docker Compose to install OpenDataDiscovery utilizing the demo.yaml
docker-compose -f docker/demo.yaml up -d --build odd-platform odd-collector
docker-compose -f docker/domo.yaml up -d --build

# clean up
docker-compose -f docker/demo.yaml down 

# Verify the services are up and running
docker ps | grep opendatadiscovery

# If all is well, you'll get response like 
8344b643aa83   ghcr.io/opendatadiscovery/odd-platform:latest   "java -cp @/app/jib-…"   4 hours ago   Up 4 hours   0.0.0.0:8080->8080/tcp   docker-odd-platform-1


#Access the openDataDicovery Web Application
Once the services are up, you can access the openDataDicovery frontend by navigating to http://localhost:5000 in your web browser.
ENDPOINT_URL="http://localhost:8080/"
http://localhost:8081/


- delete files in sample data

docker-compose -f docker/docker-compose.yaml restart


#LOGS
docker-compose -f docker/docker-compose.yaml logs odd-platform
docker-compose -f docker/docker-compose.yaml logs --tail=20 odd-platform

docker-compose -f docker/docker-compose.yaml logs odd-collector
docker-compose -f docker/docker-compose.yaml logs --tail=20 odd-collector


docker-compose -f docker/docker-compose.yaml restart odd-platform
docker-compose -f docker/docker-compose.yaml restart odd-collector

