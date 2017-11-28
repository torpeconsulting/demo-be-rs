# Install JBoss AS
FROM jboss/base-jdk:8 as JBOSS
ENV JBOSS_VERSION 7.0.0
ENV JBOSS_HOME /opt/jboss/jboss-eap-7.0/
COPY jboss-eap-$JBOSS_VERSION.zip $HOME
RUN cd $HOME \
    && unzip jboss-eap-$JBOSS_VERSION.zip \
    && rm jboss-eap-$JBOSS_VERSION.zip
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
RUN ls -l /opt

# Deploy WAR
RUN cp target/restbe.war /opt/jboss/jboss-eap-7.0/standalone/deployments/

# Start JBoss AS
CMD ["/opt/jboss/jboss-eap-7.0/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
