FROM gradle:4.6-jdk8 as build

RUN mkdir -p /home/gradle/app
WORKDIR /home/gradle/app
COPY build.gradle gradle.properties settings.gradle ./
RUN gradle assemble
RUN gradle build

FROM java:8
RUN mkdir -p /home/java/app
RUN mkdir -p /etc/cas/config && mkdir -p /etc/cas/logs
COPY etc/cas/config/ /etc/cas/config/
WORKDIR /home/java/app
COPY --from=build /home/gradle/app/build/libs/cas.war .
ENTRYPOINT ["java"]
CMD ["-jar", "cas.war"]
