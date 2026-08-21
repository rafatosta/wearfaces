# Essential

Essential é um mostrador minimalista de fundo AMOLED preto com estilos Digital
e Analógico no mesmo APK. Exibe hora, data, bateria e dois campos superiores
opcionais, com cores, intensidade do realce e marcadores configuráveis.

- Package ID: `com.rtosta.wearfaces.essential`
- Especificação: [ESSENTIAL](../../docs/watchfaces/ESSENTIAL.md)
- Baseline: Wear OS 5 / API 34 / WFF 2
- Rede e telemetria: nenhuma
- Dados externos: dois campos editáveis, inicialmente vazios e sem aro
- Padrões: Digital, White, Green, Discrete e Minimal
- AOD: preserva o estilo e reduz textos, segundos, cores e marcadores

Build isolado:

```bash
./gradlew :faces:essential:assembleDebug
```

A instalação e a seleção no relógio estão descritas no README da raiz.
