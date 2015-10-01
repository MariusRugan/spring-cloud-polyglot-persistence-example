#!/usr/bin/env bash

#
# @author mariusrugan@gmail.com
#

case "$1" in
    discovery)
        APP_IMAGE="kbastani/discovery-microservice"
        APP_CONTAINER_NAME="docker_discovery_1"
        APP_CONTAINER_PORTS="-p 8761:8761"
        APP_CONTAINER_LINKS=""
        ;;
    config)
        APP_IMAGE="kbastani/config-microservice"
        APP_CONTAINER_NAME="docker_config_1"
        APP_CONTAINER_PORTS="-p 8443:8443 -p 5006:5006"
        APP_CONTAINER_LINKS="--link docker_discovery_1:discovery"
        ;;
    movie)
        APP_IMAGE="kbastani/movie-microservice"
        APP_CONTAINER_NAME="docker_movie_1"
        APP_CONTAINER_PORTS="-p 8444:8443 -p 5007:5006"
        APP_CONTAINER_LINKS="--link docker_discovery_1:discovery --link docker_config_1:config"
        ;;
    user)
        APP_IMAGE="kbastani/user-microservice"
        APP_CONTAINER_NAME="docker_user_1"
        APP_CONTAINER_PORTS="-p 8445:8443 -p 5008:5006"
        APP_CONTAINER_LINKS="--link docker_discovery_1:discovery --link docker_config_1:config"
        ;;
    *)
        echo "Usage: $0 {discovery|config|movie} {start|stop|restart|status}"
        exit 1
        ;;
esac

case "$2" in
    build)
        cd "${1}-microservice"
        mvn clean package -P docker
        cd
        ;;
    start)
        CONTAINER_STARTED=`docker ps | grep ${APP_IMAGE} | grep -v Exit`
        CONTAINER_ID=$(docker ps -a | grep -v Exit | grep ${APP_CONTAINER_NAME} | awk '{print $1}')

        if [[ ${CONTAINER_STARTED} ]]; then
            echo "ERROR: ${APP_IMAGE} is up!"
        else
            docker run ${APP_CONTAINER_PORTS} --hostname=${APP_CONTAINER_NAME} --name=${APP_CONTAINER_NAME} ${APP_CONTAINER_LINKS} -i -t ${APP_IMAGE}
        fi
        ;;
    stop)
        CONTAINER_STARTED=`docker ps | grep ${APP_IMAGE} | grep -v Exit`
        CONTAINER_ID=$(docker ps -a | grep ${APP_CONTAINER_NAME} | awk '{print $1}')

        if [[ ${CONTAINER_STARTED} ]]; then
            docker stop ${CONTAINER_ID}
        fi

        docker rm -f ${CONTAINER_ID}
        ;;
    restart)
        ;;
    status)
            docker ps -a | grep ${APP_IMAGE}
        ;;
    shell)
            docker exec -i -t ${APP_CONTAINER_NAME} bash
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|build}"
        exit 1
        ;;
esac
exit 0