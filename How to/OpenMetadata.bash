Open Data Discovery Deployment {

    Resources {
        -EC2 {
            Type:  t3.medium
            Cost: $0.0368 per hour
            RAM: 4GB
            vCPUs: 2
            Storage type: Standard disk
            Storage size: 100GB for / and 100GB for /data (scoped 100GB for root coz will be running docker images for both opdd and connectors)
            Environment: cel-log account
            Hostname: discover.yoda.cellulant.com
        }
        
        -Qualified Domain Name with SSL > discover.cellulant.africa
    }
}

Open_Metadata - 10.69.12.139 discover.yoda.cellulant.com

#SETUP

sudo yum update -y  OR sudo dnf update -y

#Install Docker

--Install Docker
sudo yum install -y docker
sudo service docker start
sudo chkconfig docker on  //activates docker service auto-start on reboot
sudo usermod -a -G docker $USER //Adds current user to docker group
sudo adduser metadata
sudo touch /var/log/metadata.log
sudo chown adm:adm /var/log/metadata.log
sudo touch /etc/default/metadata 
sudo usermod -a -G docker metadata //Adds metadata user to docker group
metadata:x:995:993::/home/metadata:/bin/false into /etc/passwd // optional
sudo mkdir /data/metadata
sudo chown metadata:metadata /data/metadata
On /etc/passwd change metabase user home dir to /data/metadata

sudo yum install -y git  
sudo reboot
    
--install docker compose for user metadata
sudo su - metadata
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}

mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

docker compose version

---
-bash-4.2$ docker compose version
Docker Compose version v2.2.3
-bash-4.2$
---

--Data directories for mysql and es
mkdir /data/metadata/mysql
mkdir /data/metadata/pgdata
mkdir /data/metadata/elasticsearch

--Download latest docker-compose.yml and edit below:

#For MySQL:
MYSQL_ROOT_PASSWORD to your_password (J1x3v7cykIhUnBXp)
./docker-volume/db-data to /data/metadata/mysql
es-data to /data/metadata/elasticsearch

#For PostgreSQL:
MYSQL_ROOT_PASSWORD to your_password (J1x3v7cykIhUnBXp)
./docker-volume/db-data-postgres to /data/metadata/pgdata
es-data to /data/metadata/elasticsearch

--Deploy openMetadata
mkdir -p $PWD/docker-volume/db-data //creates directory for host volumes
To use postgres:
mv docker-compose-postgres.yml docker-compose.yml
docker compose up -d //Deploys Openmetadata for PostgreSQL, OpenMetadat-Server, OpenMetadata-Ingestion and Elasticsearch

Output:

---
-bash-4.2$ docker compose up -d
[+] Running 69/69
 ⠿ postgresql Pulled                                                                                                                                   41.9s
   ⠿ 5b5fe70539cd Pull complete                                                                                                                        17.3s
   ⠿ 254f758dbb83 Pull complete                                                                                                                        17.6s
   ⠿ a50b6f601ef0 Pull complete                                                                                                                        18.4s
   ⠿ b2a96a17b000 Pull complete                                                                                                                        19.2s
   ⠿ b08a8624844f Pull complete                                                                                                                        22.1s
   ⠿ 9fb1f8c3deef Pull complete                                                                                                                        22.8s
   ⠿ fb374f351a53 Pull complete                                                                                                                        23.1s
   ⠿ 7b3d9f705bf0 Pull complete                                                                                                                        23.5s
   ⠿ f3d332ea444d Pull complete                                                                                                                        38.0s
   ⠿ 75cc329e27c7 Pull complete                                                                                                                        38.4s
   ⠿ 58a61727853f Pull complete                                                                                                                        38.8s
   ⠿ 7092126431fd Pull complete                                                                                                                        39.1s
   ⠿ d6ae776df709 Pull complete                                                                                                                        39.3s
   ⠿ 6f3c80eed9d0 Pull complete                                                                                                                        39.9s
   ⠿ dd4be5163fea Pull complete                                                                                                                        40.1s
 ⠿ openmetadata-server Pulled                                                                                                                          39.5s
   ⠿ 0cdfa0c98ed7 Pull complete                                                                                                                         9.0s
   ⠿ 234ffca60358 Pull complete                                                                                                                        29.5s
   ⠿ 0bf9c813b0fd Pull complete                                                                                                                        29.9s
   ⠿ d7bf6a82d10d Pull complete                                                                                                                        37.3s
   ⠿ 84df0b8ddd73 Pull complete                                                                                                                        37.6s
 ⠿ elasticsearch Pulled                                                                                                                                51.7s
   ⠿ ddf49b9115d7 Pull complete                                                                                                                        34.9s
   ⠿ e736878e27ad Pull complete                                                                                                                        38.3s
   ⠿ 7487c9dcefbe Pull complete                                                                                                                        38.5s
   ⠿ 9ccb7e6e1f0c Pull complete                                                                                                                        47.9s
   ⠿ dcec6dec98db Pull complete                                                                                                                        48.1s
   ⠿ 8a10b4854661 Pull complete                                                                                                                        48.3s
   ⠿ 1e595aee1b7d Pull complete                                                                                                                        48.5s
   ⠿ 06cc198dbf22 Pull complete                                                                                                                        48.7s
   ⠿ 55b9b1b50ed8 Pull complete                                                                                                                        48.9s
 ⠿ ingestion Pulled                                                                                                                                    84.3s
   ⠿ b85a868b505f Pull complete                                                                                                                         2.8s
   ⠿ e2be974225ed Pull complete                                                                                                                         3.0s
   ⠿ 339a4e72a1f5 Pull complete                                                                                                                         3.6s
   ⠿ 988bab9f4d93 Pull complete                                                                                                                         3.7s
   ⠿ 1469e6f7b9e6 Pull complete                                                                                                                         4.1s
   ⠿ cdcbde98e167 Pull complete                                                                                                                         4.2s
   ⠿ c92097e3f6a0 Pull complete                                                                                                                         7.7s
   ⠿ 249c78e47ef4 Pull complete                                                                                                                         7.8s
   ⠿ 276e0bfe0eef Pull complete                                                                                                                        12.6s
   ⠿ 3396dd2acfa7 Pull complete                                                                                                                        45.0s
   ⠿ d506c4bf4cc4 Pull complete                                                                                                                        45.1s
   ⠿ 6f18a9719a2e Pull complete                                                                                                                        45.3s
   ⠿ 03fa41bdf5ee Pull complete                                                                                                                        45.5s
   ⠿ 0de37dbed1e5 Pull complete                                                                                                                        45.6s
   ⠿ f7b40dfd8d29 Pull complete                                                                                                                        45.8s
   ⠿ 380b2acefe8e Pull complete                                                                                                                        45.9s
   ⠿ 6ebbafb81bba Pull complete                                                                                                                        46.0s
   ⠿ 66dc60c42d0b Pull complete                                                                                                                        46.1s
   ⠿ 4f4fb700ef54 Pull complete                                                                                                                        46.3s
   ⠿ ad12b8340672 Pull complete                                                                                                                        46.5s
   ⠿ aa1b49077103 Pull complete                                                                                                                        56.4s
   ⠿ 7a419f53bcc8 Pull complete                                                                                                                        58.5s
   ⠿ 7c97a2189f8d Pull complete                                                                                                                        58.6s
   ⠿ 0c055fa6fa92 Pull complete                                                                                                                        59.2s
   ⠿ 10ec9437fa23 Pull complete                                                                                                                        59.3s
   ⠿ 9a2afa243903 Pull complete                                                                                                                        59.4s
   ⠿ b91e7c3e78ed Pull complete                                                                                                                        59.4s
   ⠿ d43ef8a1cacc Pull complete                                                                                                                        59.8s
   ⠿ 8cfc2a062524 Pull complete                                                                                                                        60.5s
   ⠿ 51d87ae1efff Pull complete                                                                                                                        81.5s
   ⠿ 329a15aab408 Pull complete                                                                                                                        81.6s
   ⠿ e10fd5dee944 Pull complete                                                                                                                        81.6s
   ⠿ 15d7f114e0d3 Pull complete                                                                                                                        81.7s
   ⠿ bf445e6c122c Pull complete                                                                                                                        81.8s
   ⠿ e7fd0cdc90e8 Pull complete                                                                                                                        81.8s
   ⠿ 0344ce8810fb Pull complete                                                                                                                        82.6s
[+] Running 9/9
 ⠿ Network metadata_app_net                        Created                                                                                              0.0s
 ⠿ Volume "metadata_ingestion-volume-dags"         Created                                                                                              0.0s
 ⠿ Volume "metadata_ingestion-volume-tmp"          Created                                                                                              0.0s
 ⠿ Volume "metadata_es-data"                       Created                                                                                              0.0s
 ⠿ Volume "metadata_ingestion-volume-dag-airflow"  Created                                                                                              0.0s
 ⠿ Container openmetadata_postgresql               Started                                                                                              5.9s
 ⠿ Container openmetadata_elasticsearch            Started                                                                                              5.9s
 ⠿ Container openmetadata_server                   Started                                                                                             17.6s
 ⠿ Container openmetadata_ingestion                Started                                                                                             19.1s
-bash-4.2$
---

--Connect Redshift
#Install plugins
pip3 install "openmetadata-ingestion[redshift]"
pip3 install "openmetadata-ingestion[redshift-usage]"

#Setup Redshift connection on GUI

--Manage
docker ps

---
-bash-4.2$ docker ps
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED              STATUS                        PORTS                                                                                  NAMES
a4d0d4fd667b   docker.getcollate.io/openmetadata/ingestion:1.0.5      "/bin/bash /opt/airf…"   About a minute ago   Up About a minute             0.0.0.0:8080->8080/tcp, :::8080->8080/tcp                                              openmetadata_ingestion
6dacd73bb5ec   docker.getcollate.io/openmetadata/server:1.0.5         "./openmetadata-star…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:8585-8586->8585-8586/tcp, :::8585-8586->8585-8586/tcp                          openmetadata_server
cfe920ecbefa   docker.elastic.co/elasticsearch/elasticsearch:7.10.2   "/tini -- /usr/local…"   About a minute ago   Up About a minute             0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   openmetadata_elasticsearch
a7f4ab1dd3cd   docker.getcollate.io/openmetadata/postgresql:1.0.5     "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp                                              openmetadata_postgresql
-bash-4.2$
---

docker stats

---
CONTAINER ID   NAME                         CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
a4d0d4fd667b   openmetadata_ingestion       1.87%     1.357GiB / 15.43GiB   8.79%     12.7MB / 6.51MB   107MB / 57.3kB    92
6dacd73bb5ec   openmetadata_server          0.25%     340.1MiB / 15.43GiB   2.15%     264kB / 514kB     1.06MB / 0B       79
cfe920ecbefa   openmetadata_elasticsearch   0.21%     1.392GiB / 15.43GiB   9.02%     3.38kB / 1.64kB   119MB / 1.77MB    52
a7f4ab1dd3cd   openmetadata_postgresql      0.60%     81.15MiB / 15.43GiB   0.51%     7.01MB / 12.9MB   8.98MB / 79.6MB   27
---

#Remove containers
docker compose down

#Recreate the containers
docker compose up -d

#MONITORING

--Newrelic install

cd /tmp
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=<API_KEY> NEW_RELIC_ACCOUNT_ID=2090373 /usr/local/bin/newrelic install

---
Installing New Relic CLI v0.68.23
Installing to /usr/local/bin using sudo

 _   _                 ____      _ _
| \ | | _____      __ |  _ \ ___| (_) ___
|  \| |/ _ \ \ /\ / / | |_) / _ | | |/ __|
| |\  |  __/\ V  V /  |  _ |  __| | | (__
|_| \_|\___| \_/\_/   |_| \_\___|_|_|\___|

Welcome to New Relic. Let's set up full stack observability for your environment.
Our Data Privacy Notice: https://newrelic.com/termsandconditions/services-notices

✔ Connecting to New Relic Platform
   Connected


Installing New Relic

==> Installing Infrastructure Agent
Created symlink from /etc/systemd/system/multi-user.target.wants/newrelic-infra.service to /etc/systemd/system/newrelic-infra.service.
Running agent status check attempt...
Agent status check ok.
Infra key: i-0f2fa1237763fadc9
✔ Installing Infrastructure Agent
   Installed

==> Installing Logs Integration
✔ Installing Logs Integration
   Installed

We've detected additional monitoring that can be configured by installing the following:
  Elasticsearch Integration
  PostgreSQL Integration

? Continue installing?  No

  New Relic installation complete

  --------------------
  Installation Summary

  −  Elasticsearch Integration  (skipped)
  ✔  Infrastructure Agent  (installed)
  ✔  Logs Integration  (installed)
  −  PostgreSQL Integration  (skipped)

  View your data at the link below:
  ⮕  https://onenr.io/0LREg08N8Qa

  View your logs at the link below:
  ⮕  https://onenr.io/08woP49KbRx

  --------------------

[ec2-user@discover tmp]$
---

#UNINSTALL

--Newrelic
sudo yum remove newrelic-infra -y

