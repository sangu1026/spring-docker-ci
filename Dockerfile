FROM gradle:8.5-jdk21 AS build
WORKDIR /app

# gradlew와 관련 파일 복사
COPY build.gradle settings.gradle gradlew* ./
COPY gradle ./gradle

# gradlew 실행 권한 추가
RUN chmod +x gradlew

# 의존성 다운로드
RUN ./gradlew dependencies --no-daemon

# 소스 전체 복사 후 빌드
COPY . .
RUN ./gradlew clean build -x test --no-daemon

# -------------------------
FROM openjdk:21-jdk-slim
WORKDIR /app

# 빌드 산출물 복사
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
