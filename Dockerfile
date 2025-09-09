# Stage 1: Build with Maven + Java 21
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the app (skip tests for faster builds)
RUN mvn package -DskipTests

# Stage 2: Runtime using Java 21
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built jar from previous stage
COPY --from=build /app/target/*.jar app.jar

# Run the app
ENTRYPOINT ["java","-jar","app.jar"]

