#!/usr/bin/env bash
#
# @author mariusrugan@gmail.com
#

case "$1" in
    discovery)
        APP="kbastani/discovery-microservice"
        APP_CONTAINER_NAME="docker_discovery_1"
        APP_PORTS="-p 8761:8761"
        ;;
    config)
        APP="kbastani/config-microservice"
        APP_CONTAINER_NAME="docker_config_1"
        APP_PORTS="-p 8443:8443 -p 5006:5006"
        ;;
    *)
        echo "Usage: $0 {discovery|config} {start|stop|restart|status}"
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
        started=`docker ps | grep ${APP}`
        CONTAINER_ID=$(docker ps -a | grep -v Exit | grep ${APP_CONTAINER_NAME} | awk '{print $1}')

        if [[ ${started} ]]; then
            echo "ERROR: ${APP} is up!"
        else
            docker run ${APP_PORTS} --hostname=${APP_CONTAINER_NAME} --name=${APP_CONTAINER_NAME} -i -t ${APP}
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
    shell)
            docker exec -i -t ${APP_CONTAINER_NAME} bash
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|build}"
        exit 1
        ;;
esac
exit 0