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
- Opensearch dashboard
- Valkey
- Redis Insight
- RabbitMq
- Varnish (Enable after installing magento)
- Mailpit
- Node (Enable after installing magento)
- Logstash
- PHP MyAdmin
- Jenkins
- Swoole

## Setup docker
- Create a directory where you want to run this docker
- Clone this Repository into the directory
- Move to the root project directory in terminal
- Run `cp .env.sample .env`
- Run `cp build.sample .build`
- Run `id` to know your current user id and group id
- Once you get, update them in .env file respectively `APP_USER_ID` and `APP_GROUP_ID`
- Run `docker compose build`
- Run `docker compose up` or `docker compose up -d`
- Check in Browser

## Install Magento 
- Make sure docker is up and running
- Move inside php-fpm container
- Remove all exisiting files and make it empty
- Now, install Magento in a usual way
- Once done, re-start docker container (Otherwise nginx.conf will not get updated)

## Improvements
- Xdebug Support
- PHP Swoole plugin Support 

## Logstash
If you are willing to use logstash, rename `docker/images/logstash/pipeline/magento.conf.sample` to `docker/images/logstash/pipeline/magento.conf`
- Recomended to use https://github.com/attherateof/LogstashWrapper for easy setup


