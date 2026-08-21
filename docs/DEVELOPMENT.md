# Desenvolvimento

## Host Fedora

Instale Git e Podman. Para dispositivo físico, mantenha um ADB funcional no
host; Android Studio é opcional. O primeiro uso baixa a imagem base, o Android
SDK e as ferramentas oficiais WFF.

```bash
./tools/dev.sh image
./tools/dev.sh validate
./tools/dev.sh test
./tools/dev.sh build aurora
./tools/dev.sh build flow
```

`dev.sh` monta somente o checkout em `/workspace` com relabel SELinux e mantém
um volume Gradle. `rebuild` força imagem limpa; `shell` abre/roda um comando no
ambiente. Detalhes estão em [CONTAINER.md](CONTAINER.md).

## Fallback nativo

Requer JDK 17, Android SDK Platform 34, Build Tools 36.0.0 e licenças aceitas.
Defina `ANDROID_HOME`/`ANDROID_SDK_ROOT` e execute:

```bash
./gradlew :faces:aurora:assembleDebug
./gradlew :faces:flow:assembleDebug
./tools/build-all.sh
```

Para `validate.sh`/`test.sh` nativos, defina `WFF_VALIDATOR_JAR` e
`WFF_MEMORY_JAR` com os JARs oficiais. `SKIP_OFFICIAL_WFF_TOOLS=1` existe
somente para diagnóstico estático explícito e não equivale à suíte aprovada.

## Ciclo no relógio

Conecte o Watch 2 conforme [ADB_WIFI.md](ADB_WIFI.md), confirme `adb devices` e
rode `./tools/install.sh aurora`. Por padrão ele valida/compila no container e
instala pelo ADB do host. `WEARFACES_NATIVE_BUILD=1` escolhe o fallback nativo.
