# Stride

Stride é um mostrador digital esportivo de fundo AMOLED preto, com hora de
leitura rápida, quatro paletas, cinco complications editáveis e AOD reduzido.

- Package ID: `com.rtosta.wearfaces.stride`
- Especificação: [STRIDE](../../docs/watchfaces/STRIDE.md)
- Baseline: Wear OS 5 / API 34 / WFF 2
- Rede e telemetria: nenhuma
- Dados externos: somente por providers de complications escolhidos pelo usuário
- Padrões: passos no topo, frequência cardíaca à esquerda e bateria abaixo;
  distância e calorias ficam vazias até a seleção de providers compatíveis
- Hora: sincronizada com a preferência 12/24 h do dispositivo

Build isolado:

```bash
./gradlew :faces:stride:assembleDebug
```

A instalação e a seleção no relógio estão descritas no README da raiz.
