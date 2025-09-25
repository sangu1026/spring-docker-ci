FROM gradle:8.5-jdk21 AS build
WORKDIR /app

# 빌드 스크립트 먼저 복사해서 캐시 최적화
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY gradlew .

# 의존성 다운로드
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon

# 전체 소스 복사
COPY . .

# gradlew가 다시 덮어써질 수 있으니 여기서 한번 더 권한 부여
RUN chmod +x gradlew

# 빌드 (테스트 제외)
RUN ./gradlew clean build -x test --no-daemon

# -------------------------
FROM openjdk:21-jdk-slim
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
