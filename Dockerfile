# If not using Jib
#FROM public.ecr.aws/docker/library/eclipse-temurin:17.0.7_7-jdk-focal
#COPY build/libs/spring-petclinic-data-jdbc-3.0.0.BUILD-SNAPSHOT.jar /usr/local/bin/spring-petclinic-data-jdbc-3.0.0.BUILD-SNAPSHOT.jar
#ENTRYPOINT ["java", "-Duser.timezone=Asia/Seoul", "-jar", "/usr/local/bin/spring-petclinic-data-jdbc-3.0.0.BUILD-SNAPSHOT.jar"]

FROM public.ecr.aws/docker/library/eclipse-temurin:17.0.7_7-jdk-focal
RUN mkdir /logs ; chmod 777 /logs
