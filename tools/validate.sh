#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

required=(
  MASTER_SPEC.md README.md LICENSE CONTRIBUTING.md CHANGELOG.md
  settings.gradle.kts build.gradle.kts gradle.properties gradlew gradlew.bat
  gradle/libs.versions.toml gradle/wrapper/gradle-wrapper.jar
  gradle/wearface-lint.xml build-logic/settings.gradle.kts
  build-logic/build.gradle.kts
  build-logic/src/main/kotlin/wearfaces.watch-face.gradle.kts
  templates/basic/build.gradle.kts templates/basic/src/main/AndroidManifest.xml
  templates/basic/src/main/res/raw/watchface.xml scripts/wearfaces
  containers/emulator/Containerfile containers/emulator/create-avd.sh
  containers/emulator/start-emulator.sh containers/emulator/emulator-package.xml
  Containerfile .containerignore containers/README.md
  docs/ARCHITECTURE.md docs/DEVELOPMENT.md docs/TESTING.md
  docs/CONTAINER.md docs/ADB_WIFI.md docs/DESIGN_GUIDELINES.md
  docs/RELEASE.md docs/ROADMAP.md docs/REFERENCE_TO_SPEC.md
  docs/watchfaces/TEMPLATE.md docs/watchfaces/SUNLIGHT.md
  tools/validate-face-specs.sh
)

for path in "${required[@]}"; do
  [[ -e "$path" ]] || { echo "Missing required path: $path" >&2; exit 1; }
done
grep -Fq 'WEARFACES_GPU_MODE=host' scripts/wearfaces &&
  grep -Fq -- '-feature -Vulkan' containers/emulator/start-emulator.sh || {
    echo "Emulator launcher must avoid the unstable SwiftShader path when host graphics are available" >&2
    exit 1
  }

common_build=build-logic/src/main/kotlin/wearfaces.watch-face.gradle.kts
grep -Eq 'minSdk[[:space:]]*=[[:space:]]*34' "$common_build" || { echo "minSdk must be 34" >&2; exit 1; }
grep -Eq 'compileSdk[[:space:]]*=[[:space:]]*35' "$common_build" || { echo "compileSdk must be 35" >&2; exit 1; }
grep -Eq 'targetSdk[[:space:]]*=[[:space:]]*35' "$common_build" || { echo "targetSdk must be 35" >&2; exit 1; }

grep -q '^FROM docker.io/library/eclipse-temurin:17.0.16_8-jdk-noble' Containerfile || {
  echo "Container base image must be fully qualified and pinned" >&2
  exit 1
}
grep -q '^USER 1000:1000$' Containerfile || {
  echo "Container must reuse numeric UID/GID 1000 for keep-id" >&2
  exit 1
}
grep -Fq 'platforms;android-35' Containerfile || { echo "Build container must install Platform 35" >&2; exit 1; }
grep -Fq 'system-images\;android-34\;android-wear\;x86_64' containers/emulator/Containerfile || {
  echo "Emulator container must install the Wear OS 5/API 34 x86_64 image" >&2
  exit 1
}
grep -Fq 'emulator-linux_x64-15917651.zip' containers/emulator/Containerfile || {
  echo "Emulator 37.1.11 archive must remain pinned" >&2
  exit 1
}
grep -Fq '<localPackage path="emulator"' containers/emulator/emulator-package.xml || {
  echo "Pinned emulator must be registered as an installed SDK package" >&2
  exit 1
}
grep -Fq 'libxkbfile1' containers/emulator/Containerfile || {
  echo "Emulator container must install libxkbfile1" >&2
  exit 1
}
grep -Fq 'ANDROID_AVD_HOME=/home/wearfaces/.android/avd' containers/emulator/Containerfile || {
  echo "Emulator container must persist AVDs in the mounted Android home" >&2
  exit 1
}
for container_launcher in tools/dev.sh scripts/wearfaces; do
  grep -Fq '"$repo_root:/workspace:z"' "$container_launcher" || {
    echo "$container_launcher must use the shared checkout SELinux label" >&2
    exit 1
  }
done
for launcher_path in scripts/wearfaces containers/emulator/start-emulator.sh; do
  grep -Fq -- '--clean-stale-locks' "$launcher_path" || {
    echo "$launcher_path must support stale AVD lock cleanup" >&2
    exit 1
  }
done
if grep -R -Fq -- '--privileged' scripts containers/emulator; then
  echo "Emulator tooling must not use --privileged" >&2
  exit 1
fi
if grep -Eq 'useradd.*(--uid|-u)[ =]?1000' Containerfile; then
  echo "Container must not create a duplicate UID 1000" >&2
  exit 1
fi
grep -Fq 'WEARFACES_ANDROID_VOLUME:-wearfaces-android-home' tools/dev.sh || {
  echo "Podman development builds must use a persistent Android home volume" >&2
  exit 1
}
grep -Fq '"$android_volume:/home/ubuntu/.android:Z"' tools/dev.sh || {
  echo "Podman development builds must persist the Android debug keystore" >&2
  exit 1
}

for script in tools/*.sh; do
  [[ -x "$script" ]] || { echo "Script is not executable: $script" >&2; exit 1; }
  head -n 5 "$script" | grep -q 'set -euo pipefail' || {
    echo "Strict shell mode missing near top of $script" >&2
    exit 1
  }
done

for script in scripts/wearfaces containers/emulator/*.sh; do
  [[ -x "$script" ]] || { echo "Script is not executable: $script" >&2; exit 1; }
  head -n 5 "$script" | grep -q 'set -euo pipefail' || {
    echo "Strict shell mode missing near top of $script" >&2
    exit 1
  }
done

./tools/validate-face-specs.sh

command -v xmllint >/dev/null || { echo "xmllint is required" >&2; exit 1; }
while IFS= read -r -d '' xml; do
  xmllint --noout "$xml"
done < <(find faces -path '*/build' -prune -o -type f -name '*.xml' -print0)

validator=${WFF_VALIDATOR_JAR:-/opt/wff-tools/wff-validator.jar}
if [[ ${SKIP_OFFICIAL_WFF_TOOLS:-0} == 1 ]]; then
  echo "WARNING: official WFF schema validation explicitly skipped" >&2
elif [[ ! -f "$validator" ]]; then
  echo "Official WFF validator not found at $validator." >&2
  echo "Use ./tools/dev.sh validate or set WFF_VALIDATOR_JAR." >&2
  exit 1
fi

module_count=0
for module in faces/*; do
  [[ -d "$module" && -f "$module/build.gradle.kts" ]] || continue
  ((module_count += 1))
  slug=${module##*/}
  manifest=$module/src/main/AndroidManifest.xml
  build_file=$module/build.gradle.kts
  watchface=$module/src/main/res/raw/watchface.xml
  info=$module/src/main/res/xml/watch_face_info.xml
  readme=$module/README.md

  for path in "$manifest" "$watchface" "$info" "$readme"; do
    [[ -f "$path" ]] || { echo "Missing required module path: $path" >&2; exit 1; }
  done

  grep -q 'android:hasCode="false"' "$manifest" || { echo "$slug must be resource-only" >&2; exit 1; }
  grep -q 'com.google.wear.watchface.format.version' "$manifest" || { echo "$slug WFF property is missing" >&2; exit 1; }
  grep -A2 'com.google.wear.watchface.format.version' "$manifest" | grep -q 'android:value="2"' || {
    echo "$slug must declare WFF 2" >&2
    exit 1
  }
  grep -Fq 'id("wearfaces.watch-face")' "$build_file" || { echo "$slug must apply the common build configuration" >&2; exit 1; }
  package_id=$(sed -n 's/.*applicationId = "\([^"]*\)".*/\1/p' "$build_file" | head -n1)
  namespace=$(sed -n 's/.*namespace = "\([^"]*\)".*/\1/p' "$build_file" | head -n1)
  [[ "$package_id" == com.rtosta.wearfaces.* && "$namespace" == "$package_id" ]] || {
    echo "$slug namespace/applicationId is incorrect" >&2
    exit 1
  }
  grep -Fq "include(\":faces:$slug\")" settings.gradle.kts || { echo "$slug is missing from settings.gradle.kts" >&2; exit 1; }
  complication_count=$(grep -c '<ComplicationSlot ' "$watchface" || true)
  if [[ $slug == aurora || $slug == flow ]]; then
    [[ $complication_count -ge 2 ]] || { echo "$slug needs at least two complication slots" >&2; exit 1; }
  elif [[ $slug == essential ]]; then
    [[ $complication_count -eq 4 ]] || { echo "$slug must declare exactly four complication slots" >&2; exit 1; }
  fi
  [[ $(grep -c '<ColorOption ' "$watchface") -ge 3 ]] || { echo "$slug needs at least three palettes" >&2; exit 1; }
  grep -q 'mode="AMBIENT"' "$watchface" || { echo "$slug needs an ambient mode" >&2; exit 1; }
  if grep -q '<DigitalClock ' "$watchface"; then
    grep -q '<TimeText ' "$watchface" || { echo "$slug digital clock is incomplete" >&2; exit 1; }
  else
    grep -q '<HourHand ' "$watchface" && grep -q '<MinuteHand ' "$watchface" || {
      echo "$slug must provide a complete analog or digital clock" >&2
      exit 1
    }
  fi
  grep -q '\[DAY\]' "$watchface" || { echo "$slug date is missing" >&2; exit 1; }

  if [[ ${SKIP_OFFICIAL_WFF_TOOLS:-0} != 1 ]]; then
    validator_output=$(java -jar "$validator" 2 "$watchface" 2>&1)
    printf '%s\n' "$validator_output"
    if grep -Eq '❌|NOT valid|SEVERE:' <<<"$validator_output"; then
      echo "Official WFF validation failed for $slug." >&2
      exit 1
    fi
  fi
done

((module_count > 0)) || { echo "No watch face modules found" >&2; exit 1; }

echo "Static and WFF validation passed."
