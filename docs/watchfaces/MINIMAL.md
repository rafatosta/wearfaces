# Minimal — especificação

## 1. Identidade e proveniência

- Nome: `Minimal`
- Slug: `minimal`
- Package ID: `com.rtosta.wearfaces.minimal`
- Estado: `aprovado`
- Tipo de referência: `prompt textual`
- Origem/autoria da referência: prompt fornecido pelo mantenedor em 2026-09-23.
- Autorização/licença: criação original a partir de requisitos abstratos.
- Referência será commitada: não; o prompt normalizado abaixo é a fonte de verdade.

## 2. Leitura da referência

### Observado

- Fundo AMOLED preto, mostrador circular, horário digital central e data curta abaixo.
- Um aro fino ocupa a borda útil: trilha cinza-grafite completa e progresso vermelho iniciado em 12 horas, no sentido horário.
- O exemplo visual solicitado mostra aproximadamente 75% de carga, sem ícones, complications ou widgets.

### Inferido

- A hora deve usar peso leve da fonte do dispositivo, centralização estrita e leitura prioritária.
- O aro deve preservar espaço entre sua borda e o limite do canvas circular.

### Decidido para a criação original

- Criar o design original Minimal, sem reproduzir fontes, ícones, marcas ou assets de terceiros.
- Usar segmentos `PartDraw`/`RoundRectangle` nativos do WFF como aro visual de 75%, pois o baseline WFF 2 deste projeto não oferece uma construção de arco de varredura ligada a `[BATTERY_PERCENT]` já validada.
- O aro é um indicador visual estático de bateria no MVP; não representa a carga real do relógio.

### Incertezas materiais

- Nenhuma para o MVP. Um anel de bateria dinâmico fica fora de escopo até haver uma construção WFF 2 validada.

## 3. Intenção e não objetivos

### Intenção

Oferecer leitura imediata de hora e data em uma superfície circular preta, com um único destaque vermelho contido no aro de bateria. A composição deve parecer silenciosa, tecnológica e refinada.

### Não objetivos

- Não copiar fontes, ícones, logotipos, imagens ou geometria proprietária.
- Não elevar WFF/API nem adicionar rede, telemetria ou coleta própria de saúde.
- Não adicionar complications, passos, clima, frequência cardíaca, atalhos, ícones ou widgets.
- Não oferecer configurações que alterem estrutura, dados ou elementos visuais; somente três variações discretas de cor para o texto são necessárias à política do repositório.
- Não declarar que o aro vetorial estático é a carga real do dispositivo.

## 4. Especificação visual

Canvas WFF: `450 x 450`; centro: `(225, 225)`.

| Camada | Elemento | X | Y | Largura | Altura | Aparência/comportamento |
| ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | Fundo | 0 | 0 | 450 | 450 | Preto AMOLED `#FF000000`. |
| 2 | Aro base | 20 | 20 | 410 | 410 | Círculo fino grafite `#FF252529`, completo. |
| 3 | Progresso | 20 | 20 | 410 | 410 | Arco vermelho `#FFFF3B30`, de 12h no sentido horário, 270 graus. |
| 4 | Hora | 45 | 150 | 360 | 108 | Hora digital central, clara e leve. |
| 5 | Data | 75 | 272 | 300 | 36 | Caixa alta cinza-clara, centralizada. |

Área segura e clipping: todos os elementos permanecem no círculo inscrito de raio 205; o aro ocupa o limite externo sem cruzar o canvas.

Tipografia: `SYNC_TO_DEVICE`, hora tamanho `94`, peso `NORMAL`; data tamanho `20`, peso `NORMAL`, com espaçamento visual obtido pelo formato curto.

## 5. Mapeamento WFF 2

| Elemento visual | Construção WFF 2 | Recurso/expressão | Comportamento dinâmico |
| --- | --- | --- | --- |
| Fundo | `Scene` | `backgroundColor="#FF000000"` | Permanente. |
| Aro de bateria | `Group` com 72 `PartDraw`/`RoundRectangle` | 54 segmentos vermelhos e 18 grafite | Aro visual estático de 75%. |
| Hora | `DigitalClock` e `TimeText` | `format="hh:mm"`, `hourFormat="SYNC_TO_DEVICE"` | Atualiza no relógio. |
| Data | `PartText` | `[DAY_OF_WEEK_S]`, `[MONTH_S]`, `[DAY]` | Atualiza no relógio. |

- Relógio: digital.
- Data: `MON, JAN 5` no idioma e abreviações do dispositivo, quando suportadas pela fonte/locale.
- Ordem final: fundo, aro, hora, data.
- Simplificação WFF 2: o círculo de bateria é uma composição geométrica nativa de exemplo a 75%, não uma leitura de `[BATTERY_PERCENT]`.

## 6. Complications

Nenhuma. O mostrador não possui slots editáveis nem providers fixos.

## 7. Configurações e paletas

| ID | Nome | Primária | Secundária | Destaque | Atenuada | Uso |
| ---: | --- | --- | --- | --- | --- | --- |
| 0 | AMOLED white | `#FFF2F2F2` | `#FFB8B8BD` | `#FFFF3B30` | `#FF252529` | Padrão: hora e data. |
| 1 | Silver | `#FFE1E1E5` | `#FF9EA0A6` | `#FFFF3B30` | `#FF252529` | Hora e data discretamente prateadas. |
| 2 | Warm white | `#FFF4EEE9` | `#FFC8BDB5` | `#FFFF3B30` | `#FF252529` | Hora e data em branco quente. |

Outras configurações: nenhuma. Fundo, aro de bateria e geometria permanecem fixos.

## 8. AOD

- Elementos mantidos: hora, data e aro.
- Elementos ocultos: nenhum.
- Redução de brilho/alpha: hora `#FFB8B8B8`, data `#FF707075`, trilha `#FF17171A` e progresso `#FF8C211C`.
- Estratégia contra excesso de pixels acesos: somente os elementos essenciais, sem segundos, animações ou complications.
- Legibilidade mínima: hora e data seguem centralizadas e visíveis.

## 9. Assets e licenças

Nenhum asset externo ou empacotado é usado. O aro, a tipografia e o restante da interface são construções WFF ou recursos de sistema.

Elementos que devem ser recriados por risco de propriedade intelectual: nenhum; todo o desenho é geométrico e original.

## 10. Acessibilidade e localização

- Hora e data têm alto contraste no fundo preto.
- A hora é a única informação crítica e não depende de cor.
- Fonte do sistema e tamanhos `94`/`20` preservam legibilidade em telas pequenas.
- A data usa abreviações localizadas do dispositivo; o preview usa `MON, JAN 5`.

## 11. Prompt normalizado para o Codex

```text
Leia MASTER_SPEC.md, docs/REFERENCE_TO_SPEC.md e docs/watchfaces/MINIMAL.md por completo. Implemente Minimal como um novo módulo em faces/minimal/, usando package ID com.rtosta.wearfaces.minimal, WFF 2, minSdk 34 e targetSdk 35.

Use a especificação como fonte de verdade. Crie um mostrador circular minimalista original para AMOLED: fundo preto, aro vetorial fino com trilha grafite completa e progresso vermelho de 270 graus iniciado em 12h no sentido horário, hora digital central grande e data curta abaixo. O preview deve mostrar 5:30 e MON, JAN 5. Não acrescente ícones, complications, widgets, passos, clima, saúde ou atalhos.

Mantenha o pacote resource-only, android:hasCode="false", offline e sem telemetria. O aro é estático a 75% neste MVP, pois não há construção WFF 2 de arco dinâmico validada pelo projeto; não o apresente como carga real. Desenhe o aro com geometria WFF nativa, atualize README, settings.gradle.kts, CHANGELOG.md e documentação. Execute ./tools/dev.sh test e gere o APK debug. Informe os testes físicos pendentes separadamente.
```

## 12. Critérios de aceite

- [x] Especificação aprovada antes da implementação.
- [x] WFF 2/minSdk 34/targetSdk 35 e `android:hasCode="false"`.
- [x] Package ID e módulo independentes.
- [x] Fundo preto, aro fino grafite/vermelho a 75%, hora e data conforme especificação.
- [x] Nenhuma complication ou widget; somente três cores de texto previstas pela política do repositório.
- [x] AOD próprio e econômico.
- [x] Geometria nativa e original documentada.
- [x] Android Lint, schema WFF e memory footprint aprovados.
- [x] APK debug produzido.
- [x] README, changelog e documentação sincronizados.

## 13. Testes físicos pendentes

Instalação, picker, horários de referência, virada da data, entrada e saída do AOD, clipping do aro, reboot, troca/retorno e atualização/reinstalação.
