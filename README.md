# Magento Docker
Dockerisation of magento open source

## Prerequisite
- Docker applipation in your system
- For windows user - WSL2

## Magento version
- Magento 2.4.8

## Environment used
- MariaDB
- Nginx
- PHP fpm
- OpenSearch
- Swoole
- Valkey
- RabbitMq
- Opensearch dashboard
- Redis Insight
- PHP MyAdmin
- Varnish
- Mailpit
- Node
- Logstash
- Jenkins

## Setup docker
- Create a directory where you want to run this docker
- Clone this Repository into the directory
- Move to the root project directory in terminal
- Run `cp .env.sample .env`
- Run `id` in your terminal to know your current user id and group id
- Once you get, update them in .env file respectively `APP_USER_ID` and `APP_GROUP_ID`
- Run `./bin/php/full-magento-installation.sh` or `./bin/php/full-magento-installation.sh --sample-data` optionally if you want to install sample data
- Check in Browser

## Improvements
- PHP Swoole plugin Support 

## Logstash
If you are willing to use logstash, rename `docker/images/logstash/pipeline/magento.conf.sample` to `docker/images/logstash/pipeline/magento.conf`
- Recomended to use https://github.com/attherateof/LogstashWrapper for easy setup

## Xdebug
- Xdebug is listning on 9003, if you want to change, change it in php.ini
- Tested in VS code
- Install PHP Debug by xdebug.org in VS Code
- Select xdebug icon from left panel
- Select "Listen for Xdebug" from drop down
- Click on green triangle icon to start listening

## Redis insight
- To connect Valkey session DB, use `redis://host.docker.internal:7379` (if you are using WSL 2)
- To connect Valkey cache DB, use `redis://host.docker.internal:8379` (if you are using WSL 2)

## Jenkins
- If you are willing to learn CI/CD pipeline, setup jenkins
- use `docker exec -it jenkins_container cat /var/jenkins_home/secrets/initialAdminPassword` to get inital admin password
