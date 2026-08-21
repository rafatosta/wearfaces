# WearFaces

Coleção open source de mostradores independentes para Wear OS, escritos em
[Watch Face Format](https://developer.android.com/training/wearables/wff). Cada
mostrador é um módulo Android resource-only e gera seu próprio APK/AAB.

## Compatibilidade

O baseline é **Wear OS 5 / Android API 34 / WFF 2**, com o Xiaomi Watch 2 como
primeiro alvo físico. Wear OS 4 não é suportado. Wear OS 5.1 e 6 são aceitos
enquanto preservarem compatibilidade com WFF 2.

## Mostradores

| Mostrador | Estado | Recursos |
| --- | --- | --- |
| [Aurora](faces/aurora/) | MVP 0.1.0 | Analógico, data, 2 complications, 4 paletas e AOD |
| [Essential](faces/essential/) | MVP 0.1.0 | Digital/Analógico, data, bateria, 2 campos editáveis sem aro, cores, marcadores e AOD |
| [Flow](faces/flow/) | MVP 0.1.0 | Analógico, data, 3 complications editáveis, 4 paletas, AMOLED preto e AOD |

Screenshots reais serão adicionadas depois da validação no dispositivo. O
preview vetorial do APK é ilustrativo e não substitui essa evidência.

## Build e testes

Podman é o ambiente oficial e reproduzível:

```bash
./tools/dev.sh test
./tools/dev.sh build aurora
./tools/dev.sh build essential
./tools/dev.sh build flow
```

O fallback nativo, para quem já possui JDK 17 e Android SDK 34, é:

```bash
./gradlew assembleDebug
./gradlew :faces:aurora:assembleDebug
./gradlew :faces:essential:assembleDebug
./gradlew :faces:flow:assembleDebug
./tools/build-all.sh
```

Consulte [desenvolvimento](docs/DEVELOPMENT.md),
[container](docs/CONTAINER.md) e [testes](docs/TESTING.md).

## Instalação ADB

Depois de conectar o relógio (`adb devices` deve mostrá-lo como `device`):

```bash
./tools/install.sh aurora
```

Use `--no-build` para reaproveitar um APK ou `--device SERIAL` quando houver
mais de um alvo. A seleção do mostrador é feita pelo picker normal do Wear OS.
O guia autocontido para Fedora e Xiaomi Watch 2 está em
[ADB por Wi-Fi](docs/ADB_WIFI.md).

## Releases e contribuição

Releases seguem SemVer coordenado e publicam um APK por módulo com checksums;
veja [RELEASE.md](docs/RELEASE.md). Contribuições são bem-vindas conforme
[CONTRIBUTING.md](CONTRIBUTING.md).

## Novo mostrador a partir de foto ou mockup

Toda referência visual passa primeiro pelo processo
[da referência à especificação](docs/REFERENCE_TO_SPEC.md) e pelo
[template obrigatório](docs/watchfaces/TEMPLATE.md). O Codex deve persistir uma
especificação autocontida — incluindo proveniência, observações, coordenadas,
WFF 2, paletas, complications, AOD, assets, prompt normalizado e aceite — antes
de implementar o novo módulo.

O código é GPL-3.0-only. Assets precisam ter autoria e licença próprias
documentadas; nenhum material proprietário da Xiaomi, Google ou terceiros é
aceito sem autorização compatível.
