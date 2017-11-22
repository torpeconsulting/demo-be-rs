FROM jboss/base-jdk:8

ENV JBOSS_VERSION 7.0.0
ENV JBOSS_HOME /opt/jboss/jboss-eap-7.0/

COPY jboss-eap-$JBOSS_VERSION.zip $HOME

RUN cd $HOME \
&& unzip jboss-eap-$JBOSS_VERSION.zip \
&& rm jboss-eap-$JBOSS_VERSION.zip

ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

EXPOSE 8080

COPY demo-be-rs/target/restbe.war /opt/jboss/jboss-eap-7.0/standalone/deployments/

CMD ["/opt/jboss/jboss-eap-7.0/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
