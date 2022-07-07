
FROM maven:3.8.0 AS maven
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
