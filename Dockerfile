# 1단계: 빌드
FROM gradle:8.5-jdk21 AS build
WORKDIR /app
COPY build.gradle settings.gradle gradlew* ./
COPY gradle ./gradle
RUN ./gradlew dependencies --no-daemon
COPY . .
RUN ./gradlew clean build -x test --no-daemon

# 2단계: 실행
FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
