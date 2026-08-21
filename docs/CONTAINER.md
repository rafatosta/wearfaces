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
`WEARFACES_IMAGE`). `rebuild` ignora cache de camadas. O cache Gradle usa o
volume `wearfaces-gradle-cache`; a assinatura debug usa o volume separado
`wearfaces-android-home`. Os nomes podem ser alterados por
`WEARFACES_GRADLE_VOLUME` e `WEARFACES_ANDROID_VOLUME`.

## SELinux, usuário e cache

O checkout é montado com `:Z`, `--userns=keep-id` mantém a autoria dos arquivos
de build e nenhum diretório amplo do home é exposto. A imagem-base Ubuntu já
reserva o UID/GID 1000; por isso o container reutiliza numericamente
`USER 1000:1000` e prepara `/home/wearfaces`, em vez de tentar criar um usuário
duplicado. Não use `--privileged` nem desative SELinux. O cache Gradle e o
diretório Android ficam em volumes nomeados distintos. O segundo é montado em
`/home/ubuntu/.android`, pois esse é o `user.home` que a JVM obtém para o UID
1000 fornecido pela imagem Temurin, mesmo com `HOME=/home/wearfaces`. Assim,
`debug.keystore` permanece estável entre contêineres efêmeros e builds
sucessivos.

O volume `wearfaces-android-home` contém material de assinatura. Não o remova
durante limpezas rotineiras. Se ele for perdido, uma nova chave será gerada e
os APKs já instalados precisarão ser desinstalados antes da reinstalação. Para
desenvolvimento em várias máquinas, mantenha uma cópia segura desse volume ou
configure um keystore explícito fora do Git.

ADB/Wireless debugging fica no host. Isso reduz permissões do container e evita
encaminhar USB/rede de desenvolvimento sem necessidade.

## Troubleshooting

- `podman: command not found`: instale Podman pelo Fedora.
- erro de relabel: confirme que o checkout pode ser rotulado e não remova `:Z`.
- download/SDK: verifique proxy, DNS e espaço; use `rebuild` após falha parcial.
- permissão em `build/`: confira `--userns=keep-id` e o UID do host.
- `UID 1000 is not unique`: reconstrua a imagem atual; versões antigas do
  `Containerfile` tentavam criar novamente o UID já fornecido pela imagem-base.
- cache Gradle suspeito: remova somente `wearfaces-gradle-cache` e reconstrua;
  não remova `wearfaces-android-home` como parte dessa operação.
- `INSTALL_FAILED_UPDATE_INCOMPATIBLE`: o pacote instalado foi assinado por
  outra chave. Desinstale-o uma única vez, reconstrua com o volume Android
  persistente e reinstale. As configurações locais do mostrador serão perdidas
  na desinstalação.

A CI configura versões equivalentes para a suíte nativa e também constrói o
`Containerfile`, evitando divergência silenciosa.
