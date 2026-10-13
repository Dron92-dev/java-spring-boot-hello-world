FROM eclipse-temurin:25-jdk

ARG GRADLE_VERSION=8.14

ENV GRADLE_HOME=/opt/gradle
ENV GRADLE_USER_HOME=/gradle-cache
ENV PATH=${GRADLE_HOME}/bin:${PATH}

RUN apt-get update && apt-get install -y curl unzip make && \
    curl -fsSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip && \
    unzip gradle.zip -d /opt && \
    mv /opt/gradle-${GRADLE_VERSION} ${GRADLE_HOME} && \
    rm gradle.zip && \
    gradle --version

WORKDIR /app

COPY build.gradle* settings.gradle* gradle.properties* Makefile ./

RUN mkdir -p src/main/java

RUN gradle build -x test --dry-run || true

COPY . .

RUN make build

EXPOSE 8080

CMD ["make", "run"]