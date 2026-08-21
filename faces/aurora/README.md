# Aurora

Aurora é o primeiro mostrador do WearFaces: um dial analógico AMOLED
original com halo difuso, data, quatro paletas, duas complications e um
modo ambiente reduzido.

- Package ID: `com.rtosta.wearfaces.aurora`
- Baseline: Wear OS 5 / API 34 / WFF 2
- Rede e telemetria: nenhuma
- Dados externos: somente por providers de complications escolhidos pelo usuário

Build isolado:

```bash
./gradlew :faces:aurora:assembleDebug
```

A instalação e a seleção no relógio estão descritas no README da raiz.
