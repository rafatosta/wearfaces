# Arquitetura

## Modelo do monorepo

Um repositório mantém políticas, ferramentas e documentação comuns, enquanto
cada diretório `faces/<slug>` é um módulo Android independente e produz um
APK/AAB próprio. Variações do mesmo design ficam no módulo via configurações
WFF. Isso evita acoplar instalações e releases de mostradores distintos.

Todos os pacotes são declarativos e resource-only: `android:hasCode="false"`,
sem Jetpack Watch Face renderer, serviços, rede ou telemetria. Assets editáveis
ficam em `shared-source/`; somente recursos necessários ao APK ficam em `res/`.

## Baseline e identidade

- WFF 2 e Wear OS 5, com `minSdk = 34`, `compileSdk = targetSdk = 35`;
- namespace coordenado `com.rtosta.wearfaces`;
- package por módulo, como `com.rtosta.wearfaces.aurora`,
  `com.rtosta.wearfaces.essential` e `com.rtosta.wearfaces.flow`;
- SemVer coordenado, iniciado em 0.1.0.

WFF 3/4 e Watch Face Push não entram no baseline. Uma elevação exige primeiro
alterar `MASTER_SPEC.md`, explicar migração/compatibilidade e sincronizar os
documentos derivados.

## Build e execução

Gradle descobre explicitamente cada módulo em `settings.gradle.kts`. O plugin
`wearfaces.watch-face`, em `build-logic/`, centraliza SDKs, Build Tools,
assinatura, tipos de build e lint; cada módulo mantém identidade e versão.
Podman fornece JDK, SDK, validadores, ADB e Android Emulator. GitHub Actions usa
os mesmos scripts locais.

## Conferência com documentação oficial (2026-08-30)

A documentação confirma WFF 2 ↔ Wear OS 5 ↔ API 34, manifest resource-only e
bundle separado por watch face. O requisito Google Play para novas submissões
Wear OS passa a API 35 em 31/08/2026; por isso somente compile/target sobem a
35. `minSdk 34` e WFF 2 preservam Wear OS 5. AGP 9.0.0, Gradle 9.1.0 e Build
Tools 36.0.0 já eram adequados e permaneceram pinados.

Fontes primárias: [visão geral](https://developer.android.com/training/wearables/wff),
[setup](https://developer.android.com/training/wearables/wff/setup),
[samples](https://github.com/android/wear-os-samples/tree/main/WatchFaceFormat) e
[ferramentas](https://github.com/google/watchface).
