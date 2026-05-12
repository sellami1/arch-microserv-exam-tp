FROM maven:3.9.15-eclipse-temurin-25-noble AS build
WORKDIR /workspace

COPY pom.xml .
COPY src src
RUN mvn -DskipTests package

FROM eclipse-temurin:25-jre-noble
WORKDIR /app

RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=build /workspace/target/*.jar app.jar

EXPOSE 8091

ENTRYPOINT ["java", "-jar", "/app/app.jar"]