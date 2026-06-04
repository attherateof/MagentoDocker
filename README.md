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
- Mailpit (Enable after installing magento)
- Node (Enable after installing magento)
- Logstash (Enable after installing magento)
- Varnish (Enable after installing magento)
- Jenkins (Enable after installing magento)

## Setup docker
- Create a directory where you want to run this docker
- Clone this Repository into the directory
- Move to the root project directory in terminal
- Run `cp .env.sample .env`
- Run `id` in your terminal to know your current user id and group id
- Once you get, update them in .env file respectively `APP_USER_ID` and `APP_GROUP_ID`
- Run `./bin/php/install-magento.sh` or `./bin/php/install-magento.sh --sample-data` optionally if you want to install sample data
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
