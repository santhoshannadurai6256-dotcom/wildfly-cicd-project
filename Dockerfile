FROM jboss/wildfly:latest
COPY app/sample-java-app/target/*.war /opt/jboss/wildfly/standalone/deployments/
EXPOSE 8080

