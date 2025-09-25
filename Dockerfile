# -------------------------
# Build stage
# -------------------------
FROM gradle:8.5-jdk21 AS build
WORKDIR /app

# gradlew와 wrapper 먼저 복사
COPY gradlew .
COPY gradle ./gradle

# gradlew 실행 권한 부여
RUN chmod +x gradlew

# 빌드 스크립트 복사
COPY build.gradle settings.gradle ./

# 의존성 캐시 (코드 바뀌어도 캐시 활용 가능)
RUN ./gradlew dependencies --no-daemon

# 전체 소스 복사
COPY . .

# 빌드 (테스트 제외)
RUN ./gradlew clean build -x test --no-daemon

# -------------------------
# Runtime stage
# -------------------------
FROM openjdk:21-jdk-slim
WORKDIR /app

# 빌드 산출물 복사
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
