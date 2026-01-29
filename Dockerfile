
FROM jboss/wildfly:latest
COPY target/wildfly-app.war /opt/jboss/wildfly/standalone/deployments/
EXPOSE 8080
