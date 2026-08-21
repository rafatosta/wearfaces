# Flow

Flow é um mostrador analógico de fundo AMOLED preto e composição simétrica, com
data, quatro paletas, três complications editáveis e modo ambiente reduzido.

- Package ID: `com.rtosta.wearfaces.flow`
- Especificação: [FLOW](../../docs/watchfaces/FLOW.md)
- Baseline: Wear OS 5 / API 34 / WFF 2
- Rede e telemetria: nenhuma
- Dados externos: somente por providers de complications escolhidos pelo usuário
- Padrões: passos à esquerda e bateria abaixo; calorias à direita após seleção
  de um provider compatível instalado
- Identidade: visor sem glifo; nenhum nome ou asset GNOME integra o APK

Build isolado:

```bash
./gradlew :faces:flow:assembleDebug
```

A instalação e a seleção no relógio estão descritas no README da raiz.
