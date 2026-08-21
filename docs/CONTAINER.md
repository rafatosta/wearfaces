# Ambiente Podman

Podman é o ambiente oficial. O `Containerfile` fixa:

- Eclipse Temurin JDK `17.0.16_8` sobre Ubuntu Noble;
- Android Command-line Tools `13114758`;
- Platform 34 e Build Tools 36.0.0;
- ferramentas `google/watchface` no commit
  `44b1855d445686ac8de5dbc95003d6f8e6623643`;
- WFF validator e memory-footprint evaluator construídos do código oficial.

## Uso

```bash
./tools/dev.sh image
./tools/dev.sh test
./tools/dev.sh build aurora
./tools/dev.sh rebuild
```

A imagem local é `localhost/wearfaces-dev:0.1.0` (alterável por
`WEARFACES_IMAGE`). `rebuild` ignora cache de camadas. Para limpeza total,
remova explicitamente essa imagem e o volume `wearfaces-gradle-cache` pelo
Podman após conferir os nomes.

## SELinux, usuário e cache

O checkout é montado com `:Z`, `--userns=keep-id` mantém a autoria dos arquivos
de build e nenhum diretório amplo do home é exposto. Não use `--privileged` nem
desative SELinux. Apenas o cache Gradle fica num volume nomeado; apagar o volume
deve continuar produzindo um build correto, apenas mais lento.

ADB/Wireless debugging fica no host. Isso reduz permissões do container e evita
encaminhar USB/rede de desenvolvimento sem necessidade.

## Troubleshooting

- `podman: command not found`: instale Podman pelo Fedora.
- erro de relabel: confirme que o checkout pode ser rotulado e não remova `:Z`.
- download/SDK: verifique proxy, DNS e espaço; use `rebuild` após falha parcial.
- permissão em `build/`: confira `--userns=keep-id` e o UID do host.
- cache suspeito: remova somente o volume nomeado e reconstrua.

A CI configura versões equivalentes para a suíte nativa e também constrói o
`Containerfile`, evitando divergência silenciosa.
