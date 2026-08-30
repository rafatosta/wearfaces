FROM docker.io/library/eclipse-temurin:17.0.16_8-jdk-noble AS wff-builder

ARG WATCHFACE_COMMIT=44b1855d445686ac8de5dbc95003d6f8e6623643
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/google/watchface.git /src/watchface \
    && git -C /src/watchface checkout "$WATCHFACE_COMMIT" \
    && cd /src/watchface/third_party/wff \
    && ./gradlew --no-daemon :specification:validator:executable-jar \
    && cd /src/watchface/play-validations \
    && ./gradlew --no-daemon :memory-footprint:executable-jar

FROM docker.io/library/eclipse-temurin:17.0.16_8-jdk-noble

ARG ANDROID_COMMAND_LINE_TOOLS=13114758
ENV ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    HOME=/home/wearfaces \
    PATH=/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/build-tools/36.0.0:$PATH \
    WFF_VALIDATOR_JAR=/opt/wff-tools/wff-validator.jar \
    WFF_MEMORY_JAR=/opt/wff-tools/memory-footprint.jar \
    GRADLE_USER_HOME=/home/wearfaces/.gradle

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl unzip git libxml2-utils \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p "$ANDROID_HOME/cmdline-tools" /opt/wff-tools \
    && curl -fsSL "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_COMMAND_LINE_TOOLS}_latest.zip" -o /tmp/cmdline-tools.zip \
    && unzip -q /tmp/cmdline-tools.zip -d /tmp/android-tools \
    && mv /tmp/android-tools/cmdline-tools "$ANDROID_HOME/cmdline-tools/latest" \
    && rm /tmp/cmdline-tools.zip \
    && yes | sdkmanager --licenses >/dev/null \
    && sdkmanager "platform-tools" "platforms;android-35" "build-tools;36.0.0" \
    && install -d -o 1000 -g 1000 "$HOME" "$GRADLE_USER_HOME" /home/ubuntu/.android

COPY --from=wff-builder /src/watchface/third_party/wff/specification/validator/build/libs/wff-validator.jar /opt/wff-tools/wff-validator.jar
COPY --from=wff-builder /src/watchface/play-validations/memory-footprint/build/libs/memory-footprint.jar /opt/wff-tools/memory-footprint.jar

USER 1000:1000
WORKDIR /workspace
CMD ["./tools/test.sh"]
