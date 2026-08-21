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

- WFF 2, Wear OS 5, `minSdk = compileSdk = targetSdk = 34`;
- namespace coordenado `com.rtosta.wearfaces`;
- package por módulo, como `com.rtosta.wearfaces.aurora`,
  `com.rtosta.wearfaces.essential` e `com.rtosta.wearfaces.flow`;
- SemVer coordenado, iniciado em 0.1.0.

WFF 3/4 e Watch Face Push não entram no baseline. Uma elevação exige primeiro
alterar `MASTER_SPEC.md`, explicar migração/compatibilidade e sincronizar os
documentos derivados.

## Build e execução

Gradle descobre explicitamente cada módulo em `settings.gradle.kts`. Podman
fornece JDK/SDK e os validadores; ADB permanece no host. GitHub Actions usa os
mesmos scripts locais.

## Conferência com documentação oficial (2026-08-21)

A documentação atual confirma WFF 2 ↔ Wear OS 5 ↔ API 34, o manifest
resource-only e um bundle separado por watch face. O sample oficial passou a
usar AGP 9.0.0 e `targetSdk` mais novo; WearFaces mantém 34 deliberadamente
porque a especificação proíbe ampliar o baseline sem decisão explícita. O AGP
9.0.0 exige Build Tools 36.0.0, que é usado como ferramenta de empacotamento sem
alterar `compileSdk`, `targetSdk`, `minSdk` ou a versão WFF.

Fontes primárias: [visão geral](https://developer.android.com/training/wearables/wff),
[setup](https://developer.android.com/training/wearables/wff/setup),
[samples](https://github.com/android/wear-os-samples/tree/main/WatchFaceFormat) e
[ferramentas](https://github.com/google/watchface).
