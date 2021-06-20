#!/bin/bash
# exec &>/tmp/wagui_boot_script.log
# Run Fail Safe Command
# set -euxo pipefail

#########################
### Web Install & Run ###
#########################

export CONTAINER_DIR="${HOME_DIR}/Docker/Wagui"
# export NETWORK=${VULTR_IP}

echo ${CONTAINER_DIR}

## create dir for Docker container
mkdir -p ${CONTAINER_DIR} && cd "${CONTAINER_DIR}"

# add ENV for docker-compose.yml use
echo "CONTAINER_DIR=${CONTAINER_DIR}" >> .env

echo "NETWORK=${NETWORK}" >> .env

echo "DOMAIN_NAME_1=${DOMAIN_NAME_1}" >> .env

echo "DOMAIN_NAME_2=${DOMAIN_NAME_2}" >> .env

echo "DOMAIN_NAME_3=${DOMAIN_NAME_3}" >> .env

echo "DEFAULT_EMAIL=${DEFAULT_EMAIL}" >> .env

## add website dir
mkdir html && cd html
## import web files
curl -LO https://github.com/NH3R717/Wagui-Restaurant/archive/refs/heads/master.zip
## uncompress webfiles and remove master.zip 
unzip master.zip && rm -rf master.zip
## remove unnecessary files
cd Wagui-Restaurant-master && sudo rm -f README.md .gitignore dockerfile wagui_install.sh docker-compose.yml LICENSE  
## copy files from Wagui-Restaurant-master to WebFiles
cp -a . .. && cd .. && sudo rm -rf Wagui-Restaurant-master && cd ..
pwd
# import docker-compose.yml
sudo curl -L https://raw.githubusercontent.com/NH3R717/Wagui-Restaurant/master/docker-compose.yml > docker-compose.yml
# create nginx network
#! sudo docker network create ${NETWORK}
# build and run container w/ ENV
sudo docker-compose up -d --build
 
# set to user permissions
sudo chmod 0750 "${CONTAINER_DIR}"
sudo chown --recursive \
"${USERNAME}":"${USERNAME}" "${CONTAINER_DIR}"
# remove .env = (problems w/ docker-compose down)
# rm -f .env

###################################*
### Useful Commands & Notes here ###
###################################*

# sudo curl -L https://raw.githubusercontent.com/NH3R717/Wagui-Restaurant/master/wagui_install.sh | exec bash
# sudo docker stop web_wagui && sudo docker container prune && sudo docker image prune && sudo rm -rf ~/Docker/Wagui