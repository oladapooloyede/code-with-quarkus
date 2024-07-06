FROM registry.access.redhat.com/ubi8/openjdk-17:1.19

ENV LANGUAGE='en_US:en'

RUN ./mwnw clean package

RUN echo "PWD is: $PWD"
RUN ls /home/jboss

COPY target/lib/* /deployments/lib/
COPY target/*-runner.jar /deployments/quarkus-run.jar

EXPOSE 8080
USER 185
ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"

ENTRYPOINT [ "/opt/jboss/container/java/run/run-java.sh" ]
