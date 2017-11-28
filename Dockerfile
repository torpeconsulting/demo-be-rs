# Install JBoss AS
FROM jboss/base-jdk:8 as JBOSS
ENV WILDFLY_VERSION 9.0.2.Final
ENV JBOSS_HOME /opt/jboss/wildfly
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && tar xz -f wildfly-$WILDFLY_VERSION.tar.gz \
    && mkdir -p /opt/jboss \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz
ENV LAUNCH_JBOSS_IN_BACKGROUND true
USER jboss
EXPOSE 8080
 
# Fetch Backend code
FROM alpine/git as JAVA
RUN git clone https://github.com/torpeconsulting/demo-be-rs-java.git /src
WORKDIR /src
RUN pwd
RUN ls -l

# Build WAR
FROM maven
WORKDIR /app
COPY --from=JAVA /src /app
RUN mvn package
COPY --from=JBOSS /opt/jboss /opt/jboss

# Deploy WAR
RUN cp target/restbe.war /opt/jboss/wildfly/standalone/deployments/

# Start JBoss AS
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
