FROM java:8

RUN apt-get update && apt-get install -y \
    net-tools

VOLUME /tmp
RUN mkdir -p /opt/app/logs

ADD config-microservice-0.1.0.jar config-microservice-0.1.0.jar
ADD config-microservice.jks config-microservice.jks
RUN bash -c 'touch /config-microservice-0.1.0.jar'
RUN bash -c 'touch /config-microservice-0.1.0.jks'
EXPOSE 5006
EXPOSE 8443
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5006","-jar","/config-microservice-0.1.0.jar"]
