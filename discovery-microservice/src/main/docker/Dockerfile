FROM java:8

RUN apt-get update && apt-get install -y \
    net-tools

VOLUME /tmp
ADD discovery-microservice-0.1.0.jar app.jar
RUN bash -c 'touch /app.jar'
EXPOSE 8761
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
