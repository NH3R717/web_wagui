#!/bin/bash
# exec &>/tmp/wagui_boot_script.log
# Run Fail Safe Command
# set -euxo pipefail

#########################
### Web Install & Run ###
#########################

## create dir for Docker container
export CONTAINER_DIR="${HOME_DIR}/Docker/Wagui"
mkdir -p ${CONTAINER_DIR} && cd "${CONTAINER_DIR}"
# add ENV for docker-compose.yml use
echo "CONTAINER_DIR=${CONTAINER_DIR}" >> .env

echo "NETWORK=${NETWORK}" >> .env

echo "DOMAIN_NAME_1=${DOMAIN_NAME_1}" >> .env

echo "DOMAIN_NAME_2=${DOMAIN_NAME_2}" >> .env

echo "DOMAIN_NAME_3=${DOMAIN_NAME_3}" >> .env

echo "DEFAULT_EMAIL=${DEFAULT_EMAIL}" >> .env


## Add website dir
mkdir html && cd html && sudo rm -f ${PWD}
## Import web files
curl -LO https://github.com/NH3R717/Wagui-Restaurant/archive/refs/heads/dev.zip
## uncompress webfiles and remove *.zip 
unzip dev.zip && rm -rf dev.zip
## remove unnecessary files
cd Wagui-Restaurant-dev && sudo rm README.md .gitignore dockerfile wagui_install.sh docker-compose.yml LICENSE  
## Copy files from *-master to WebFiles
cp -a . .. && cd .. && sudo rm -rf web_test-master && cd ..
pwd
# import docker-compose.yml
sudo curl -L https://raw.githubusercontent.com/NH3R717/Wagui-Restaurant/dev/docker-compose.yml > docker-compose.yml

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

# sudo curl -L https://raw.githubusercontent.com/NH3R717/Wagui-Restaurant/dev/wagui_install.sh | exec bash
# sudo docker stop web_wagui && sudo docker container prune && sudo docker image prune && sudo rm -rf ~/Docker/Wagui
