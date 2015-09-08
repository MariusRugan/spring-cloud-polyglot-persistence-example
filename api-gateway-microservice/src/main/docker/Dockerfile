FROM java:8

RUN apt-get update && apt-get install -y \
    net-tools

VOLUME /tmp
RUN mkdir -p /opt/app/logs

ADD api-gateway-microservice-0.1.0.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar","-Dcom.sun.management.jmxremote.rmi.port=1898","-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8002"]
