# Desenvolvimento

## Host mínimo

Instale Git, Bash e Podman. Android Studio, JDK, Gradle, Android SDK, ADB e
Android Emulator não são requisitos do host. Para emulação, habilite KVM e use
uma sessão Wayland ou X11/XWayland; `/dev/dri` é recomendado para gráficos.

```bash
./scripts/wearfaces doctor
./scripts/wearfaces validate
./scripts/wearfaces build-all
./scripts/wearfaces bundle essential
```

`scripts/wearfaces` é a interface pública. `tools/dev.sh` permanece como camada
compatível de baixo nível para CI e automações existentes. Ele monta somente o
checkout em `/workspace` com relabel SELinux e mantém
volumes separados para o cache Gradle e para o diretório Android do usuário
Java. O segundo preserva o `debug.keystore`, de modo que APKs de desenvolvimento
sucessivos usem a mesma assinatura. `rebuild` força imagem limpa; `shell`
abre/roda um comando no ambiente. Detalhes estão em
[CONTAINER.md](CONTAINER.md).

## Emulador e preview

```bash
./scripts/wearfaces emulator
# ou, sem janela:
./scripts/wearfaces emulator --headless

# Em outro terminal, com o emulador pronto:
./scripts/wearfaces preview essential
```

`preview` valida, compila, inicia o emulador em background se necessário,
aguarda o boot, instala e usa o broadcast de desenvolvimento documentado pelo
codelab oficial para ativar o WFF. Se o fabricante/imagem não expuser esse
broadcast, selecione o mostrador pelo picker.

## Fallback nativo opcional

Requer JDK 17, Android SDK Platform 35, Build Tools 36.0.0 e licenças aceitas.
Defina `ANDROID_HOME`/`ANDROID_SDK_ROOT` e execute:

```bash
./gradlew :faces:aurora:assembleDebug
./gradlew :faces:essential:assembleDebug
./gradlew :faces:flow:assembleDebug
./tools/build-all.sh
```

Para `validate.sh`/`test.sh` nativos, defina `WFF_VALIDATOR_JAR` e
`WFF_MEMORY_JAR` com os JARs oficiais. `SKIP_OFFICIAL_WFF_TOOLS=1` existe
somente para diagnóstico estático explícito e não equivale à suíte aprovada.

## Ciclo em relógio físico

Conecte o Watch 2 conforme [ADB_WIFI.md](ADB_WIFI.md) e rode
`./scripts/wearfaces install aurora --device SERIAL`. O ADB usado pela interface
oficial pertence à imagem do emulador; ADB no host permanece apenas um fallback
opcional para diagnóstico manual.
