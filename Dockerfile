FROM debian:latest as build-stage

RUN apt-get update && apt-get install -y zlib1g

FROM busybox:stable-glibc

RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY ./jre /opt/app/jre

COPY --from=build-stage /lib/x86_64-linux-gnu/libz.so.1 /lib
COPY --from=build-stage /lib/x86_64-linux-gnu/libdl.so.2 /lib
COPY --from=build-stage /lib/x86_64-linux-gnu/librt.so.1 /lib

ENV JAVA_HOME=/opt/app/jre
ENV PATH="$JAVA_HOME/bin:${PATH}"

COPY ./target/*.jar /opt/app/app.jar

ENTRYPOINT ["java", "-jar", "/opt/app/app.jar"]
