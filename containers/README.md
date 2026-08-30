# Container de desenvolvimento

O `Containerfile` da raiz é a definição do ambiente oficial de build. Não há
imagem pré-compilada obrigatória: `./tools/dev.sh` cria
`localhost/wearfaces-dev:0.1.0` localmente e mantém volumes nomeados separados
para o cache Gradle e o Android home que contém a assinatura debug. Consulte
[`docs/CONTAINER.md`](../docs/CONTAINER.md).

O ambiente de execução é deliberadamente separado em
`emulator/Containerfile`; `./scripts/wearfaces emulator` cria a imagem e o AVD
Wear OS 5/API 34 sem aumentar a imagem de build.
