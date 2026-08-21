# Flow

Flow é um mostrador analógico AMOLED de composição simétrica, com glifo
provisório próprio, data em dois níveis, quatro paletas, duas complications e
modo ambiente reduzido.

- Package ID: `com.rtosta.wearfaces.flow`
- Especificação: [FLOW](../../docs/watchfaces/FLOW.md)
- Baseline: Wear OS 5 / API 34 / WFF 2
- Rede e telemetria: nenhuma
- Dados externos: somente por providers de complications escolhidos pelo usuário
- Identidade: glifo Flow provisório; nenhum nome ou asset GNOME integra o APK

Build isolado:

```bash
./gradlew :faces:flow:assembleDebug
```

A instalação e a seleção no relógio estão descritas no README da raiz.
