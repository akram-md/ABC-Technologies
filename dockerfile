FROM iamdevopstrainer/tomcat:base
COPY abc.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]