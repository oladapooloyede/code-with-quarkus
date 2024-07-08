FROM maven:3-openjdk-11 AS builder
COPY ./pom.xml /usr/src/app/
RUN mvn -f /usr/src/app/pom.xml -B de.qaware.maven:go-offline-maven-plugin:resolve-dependencies
COPY src /usr/src/app/src
WORKDIR /usr/src/app
RUN mvn -DskipTests=true -Dquarkus.package.type=mutable-jar -B de.qaware.maven:go-offline-maven-plugin:resolve-dependencies clean package

FROM fabric8/java-alpine-openjdk8-jre
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV AB_ENABLED=jmx_exporter
COPY --from=build /usr/src/app/target/lib/* /deployments/lib/
COPY --from=build /usr/src/app/target/*-runner.jar /deployments/app.jar
ENTRYPOINT [ "/deployments/run-java.sh" ]
