FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app

# Copy Maven wrapper and project descriptor first for better layer caching.
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw

# Copy sources and build the application jar.
COPY src/ src/
RUN ./mvnw -B -DskipTests clean package

FROM eclipse-temurin:21-jre
WORKDIR /app

# Use the finalName from pom.xml: springboot-github-action.jar
COPY --from=builder /app/target/springboot-github-action.jar app.jar

EXPOSE 8080
ADD target/springboot-github-action.jar springboot-github-action.jar

ENTRYPOINT ["java", "-jar", "/springboot-github-action.jar"]
