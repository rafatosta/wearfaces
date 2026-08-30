# Ambiente Podman

Podman é o ambiente oficial. O `Containerfile` fixa:

- Eclipse Temurin JDK `17.0.16_8` sobre Ubuntu Noble;
- Android Command-line Tools `13114758`;
- Platform 35 e Build Tools 36.0.0;
- ferramentas `google/watchface` no commit
  `44b1855d445686ac8de5dbc95003d6f8e6623643`;
- WFF validator e memory-footprint evaluator construídos do código oficial.

## Uso

```bash
./tools/dev.sh image
./tools/dev.sh test
./tools/dev.sh build aurora
./tools/dev.sh lint aurora
./tools/dev.sh bundle aurora
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
duplicado. No container de build, não use `--privileged` nem desative o label
SELinux. O cache Gradle e o
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

## Emulador Wear OS separado

`containers/emulator/Containerfile` não altera nem aumenta a imagem de build.
Ele fixa Command-line Tools `13114758`, Platform Tools `37.0.1`, Emulator
`37.1.11`, system image `system-images;android-34;android-wear;x86_64` revisão 1
e perfil redondo `wearos_large_round`; portanto, o host de emulação precisa ser
Linux x86_64. O catálogo foi conferido com
`sdkmanager --list` em 2026-08-30.

```bash
./scripts/wearfaces emulator
./scripts/wearfaces emulator --headless
./scripts/wearfaces emulator --x11
./scripts/wearfaces emulator --recreate --wipe-data
```

O AVD `wearfaces-wearos5` fica no volume `wearfaces-avd-wearos5`; o SDK e a
system image ficam na imagem. A execução rootless passa somente `/dev/kvm`,
preserva os grupos suplementares com `--group-add keep-groups` e passa
`/dev/dri` quando disponível. `--privileged` não é usado. Para sockets gráficos
do usuário, o container desativa apenas o label SELinux dessa execução; o
checkout continua usando relabel `:Z` nos containers de build/ADB.

O Emulator 37 distribuído para Linux não inclui o plugin Qt Wayland. Em uma
sessão Wayland, a janela usa automaticamente a ponte XWayland com o plugin
`xcb`; X11 nativo usa o mesmo caminho. Headless usa `-no-window`. Fechar o
processo encerra o emulador, mas preserva o AVD. Use
`podman volume rm wearfaces-avd-wearos5` somente quando quiser perder
deliberadamente os dados do dispositivo virtual.

ADB e Android SDK não são necessários no host. Um container persistente chamado
`wearfaces-adb` mantém o servidor e as chaves no mesmo volume do AVD, limitado a
`127.0.0.1:5038` para não conflitar com um ADB nativo na porta 5037. `install`,
`preview` e `adb` usam esse servidor para emuladores e dispositivos Wi-Fi.

## Troubleshooting

- `KVM PMU virtualization is disabled`: confira
  `cat /sys/module/kvm/parameters/enable_pmu`. O valor `N` faz o guest acessar
  MSRs de performance não virtualizados e, neste host, encerra o QEMU com
  `SIGSEGV`. No Fedora, execute
  `sudo grubby --update-kernel=ALL --args='kvm.enable_pmu=1'`, reinicie e
  confirme o valor `Y` com `./scripts/wearfaces doctor`.
- Fedora 44 com kernel `7.1.0` a `7.1.10`: essa série encerra o processo QEMU
  do Android Emulator com `SIGSEGV` logo após o KVM iniciar o guest. Reinicie,
  abra **Advanced options for Fedora Linux** no GRUB e selecione o kernel
  `6.19.x`; `./scripts/wearfaces doctor` bloqueia antecipadamente essa combinação.
- `Running multiple emulators with the same AVD`: o launcher oficial remove
  automaticamente locks órfãos do AVD depois de confirmar que o contêiner
  gerenciado não está ativo; não execute uma segunda instância manual no mesmo
  volume.
- `podman: command not found`: instale Podman pelo Fedora.
- `/dev/kvm` ausente ou sem permissão: habilite VT-x/AMD-V, instale KVM,
  adicione o usuário ao grupo `kvm` e entre novamente na sessão.
- erro `Could not find the Qt platform plugin "wayland"`: reconstrua a imagem;
  o launcher atual seleciona `xcb` e monta o socket X11/XWayland. Se `$DISPLAY`
  não estiver definido, habilite XWayland ou use `--headless`.
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
