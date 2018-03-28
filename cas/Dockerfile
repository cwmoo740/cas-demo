FROM gradle:4.6-jdk8 as build

RUN mkdir -p /home/gradle/app
WORKDIR /home/gradle/app
COPY --chown=gradle:gradle build.gradle gradle.properties settings.gradle ./
RUN gradle resolveDependencies
COPY --chown=gradle:gradle . ./
RUN gradle build

FROM java:8
RUN mkdir -p /home/java/app && mkdir -p /etc/cas/logs
WORKDIR /home/java/app
COPY ssl/cas-demo.der .
COPY resources ./resources
RUN keytool -import -keystore "${JAVA_HOME}/jre/lib/security/cacerts" -file cas-demo.der -alias cas-demo -storepass changeit -noprompt
COPY --from=build /home/gradle/app/build/libs/cas.war .
ENTRYPOINT ["java"]
CMD ["-Dspring.profiles.active=docker", "-Xmx2048M", "-jar", "cas.war"]
