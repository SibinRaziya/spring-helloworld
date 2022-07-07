
FROM maven:3.6-jdk-11 as maven_build
WORKDIR /app

COPY pom.xml .
# To resolve dependencies in a safe way (no re-download when the source code changes)
RUN mvn package

# To package the application
COPY src ./src
RUN mvn clean package -Dmaven.test.skip


# For Java 11, try this
FROM adoptopenjdk/openjdk11:alpine-jre

COPY --from=build /home/app/target/spring-boot-web.jar /usr/local/lib/demo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]
