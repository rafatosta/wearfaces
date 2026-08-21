# Container de desenvolvimento

O `Containerfile` da raiz é a definição única do ambiente oficial. Não há
imagem pré-compilada obrigatória: `./tools/dev.sh` cria
`localhost/wearfaces-dev:0.1.0` localmente e mantém apenas o cache Gradle em
volume nomeado. Consulte [`docs/CONTAINER.md`](../docs/CONTAINER.md).
