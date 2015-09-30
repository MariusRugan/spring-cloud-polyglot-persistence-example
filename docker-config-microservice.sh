#!/usr/bin/env bash

APP="kbastani/config-microservice"
APP_CONTAINER_NAME="docker_config_1"

case "$1" in
    start)
        started=`docker ps | grep ${APP}`
        CONTAINER_ID=$(docker ps -a | grep -v Exit | grep ${APP_CONTAINER_NAME} | awk '{print $1}')

        if [[ ${started} ]]; then
            echo "ERROR: ${APP} is up!"
        else
            docker run -p 8443:8443 -p 5006:5006 --name=${APP_CONTAINER_NAME} -i -t ${APP}
        fi
        ;;
    stop)
        CONTAINER_ID=$(docker ps -a | grep ${APP_CONTAINER_NAME} | awk '{print $1}')
        docker stop ${CONTAINER_ID}
        docker rm -f ${CONTAINER_ID}
        ;;
    restart)
        ;;
    status)
            docker ps -a | grep ${APP}
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
exit 0