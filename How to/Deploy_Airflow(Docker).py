 https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html
 
 #Install Docker

 --Install Docker
sudo yum install -y docker
sudo service docker start
sudo chkconfig docker on  # activates docker service auto-start on reboot
sudo usermod -a -G docker $USER # Adds current user to docker group
 
sudo adduser airflow
sudo touch /var/log/airflow.log
sudo chown adm:adm /var/log/airflow.log
sudo touch /etc/default/airflow
sudo usermod -a -G docker airflow
sudo mkdir /data/
sudo mkdir /data/airflow
sudo chown airflow:airflow /data/airflow 
nano /etc/passwd  #change airflow user home dir to /data/airflow  

sudo yum install -y git
# sudo reboot

 # install docker compose for user airflow
su - airflow # switch to airflow user or sudo su - airflow
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}

mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

docker compose version

 # Running Airflow in Docker
 # https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html

curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.10.2/docker-compose.yaml'
mkdir -p ./dags ./logs ./plugins ./config ./inputs ./outputs
echo -e "AIRFLOW_UID=$(id -u)" > .env

AIRFLOW_UID=50000

docker compose up airflow-init

docker compose up

docker compose up -d # run deamon

# In a second terminal you can check the condition of the containers and make sure that no containers are in an unhealthy condition:
docker ps

      
# Accessing the environment
docker compose run airflow-worker airflow info

#make your work easier and download a optional wrapper scripts that will allow you to run commands with a simpler command.
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.7.0/airflow.sh'
chmod +x airflow.sh

./airflow.sh info


# Sending requests to the REST API
ENDPOINT_URL="http://localhost:8080/"
curl -X GET  \
    --user "airflow:airflow" \
    "${ENDPOINT_URL}/api/v1/pools"

# Cleaning up
docker compose down --volumes --rmi all


docker restart $(docker ps -q)
