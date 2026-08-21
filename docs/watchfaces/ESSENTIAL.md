# Essential — especificação

## 1. Identidade e proveniência

- Nome: `Essential`
- Slug: `essential`
- Package ID: `com.rtosta.wearfaces.essential`
- Estado: `aprovado para implementação`
- Tipo de referência: `mockup`
- Origem/autoria da referência: imagem e briefing
  `PROMPT_CODEX_ESSENTIAL.md` fornecidos pelo mantenedor em 2026-08-21.
- Autorização/licença: uso como direção visual e funcional; nenhum elemento da
  carcaça, render do relógio ou controle ilustrado será incorporado ao APK.
- Referência será commitada: `não`; somente a especificação autocontida e os
  assets originais derivados das decisões abaixo serão versionados.

## 2. Leitura da referência

### Observado

- Um único mostrador é apresentado em versões Digital e Analógica.
- Ambos usam fundo preto, hora dominante, data curta e bateria percentual.
- O Digital não possui escala; o Analógico usa ponteiros finos e marcadores
  periféricos discretos.
- Verde é usado como realce, enquanto branco e cinza formam a hierarquia
  principal.
- O mockup mostra seletores de estilo, cores, bateria e seis marcadores.

### Inferido

- A fonte aparente é uma sans leve, sem indicação de família licenciada.
- As cores e coordenadas são aproximações visuais, não valores extraídos.
- O mockup não comprova comportamento 12/24 h, AOD ou persistência das opções.

### Decidido para a criação original

- Usar apenas primitivas WFF, fonte do sistema e quatro imagens de mãos/preview
  criadas no projeto; não usar a imagem de referência no APK.
- Implementar Digital e Analógico no mesmo XML por `ListConfiguration` e
  reavaliar a cena com `Condition`, sem aninhar usos de configurações.
- Mostrar somente hora, data e `[BATTERY_PERCENT]`; não criar complications.
- Padrões: Digital, White, Green, Discrete e Minimal.
- A opção de marcadores permanece visível no editor Digital, mas não produz
  efeito nele. Ocultá-la condicionalmente exigiria hierarquia de configurações,
  recurso posterior ao WFF 2.

### Incertezas materiais

- Nenhuma. Ajustes físicos de fonte e clipping permanecem testes pendentes no
  Xiaomi Watch 2, sem alterar as decisões funcionais.

## 3. Intenção e não objetivos

### Intenção

Oferecer somente hora, data e bateria, aproveitando o canvas circular com alto
contraste e poucos pixels permanentemente acesos. Digital e Analógico são duas
expressões do mesmo produto e compartilham cores, intensidade e AOD.

### Não objetivos

- não copiar carcaça, fontes, controles, ícones ou geometria proprietária;
- não elevar WFF/API nem adicionar renderer legado;
- não adicionar rede, telemetria ou coleta própria de saúde;
- não oferecer passos, frequência cardíaca, clima, agenda ou atalhos;
- não criar complication slots, barras, arcos, cards, gradientes ou glow;
- não alegar economia percentual de bateria sem medição.

## 4. Especificação visual

Canvas WFF: `450 × 450`; centro: `(225, 225)`.

| Camada | Elemento | X | Y | Largura | Altura | Aparência/comportamento |
| ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | Fundo | 0 | 0 | 450 | 450 | preto AMOLED `#FF000000`, sem imagem ou efeito |
| 2 | Marcadores analógicos | 0 | 0 | 450 | 450 | opção selecionada, próxima ao raio `205`, ausente no Digital |
| 3 | Hora Digital | 35 | 135 | 380 | 105 | `hh:mm` integralmente na Main Color; `82 px`, peso normal |
| 4 | Data Digital | 100 | 250 | 250 | 34 | `%s | %02d | %s`, cinza, centralizada |
| 5 | Bateria Digital | 150 | 347 | 150 | 38 | percentual simples, cinza, sem rótulo ou contorno |
| 6 | Ponteiros analógicos | 0 | 0 | 450 | 450 | horas/minutos claros e estreitos; segundos finos com realce |
| 7 | Pivô analógico | 217 | 217 | 16 | 16 | dois círculos pequenos, sem brilho |
| 8 | Data Analógica | 105 | 298 | 240 | 32 | mesma data curta, abaixo do pivô |
| 9 | Bateria Analógica | 160 | 337 | 130 | 32 | percentual simples abaixo da data |

Área segura, clipping e pivôs: texto essencial fica no círculo de raio
`185`; marcadores alcançam no máximo o raio `207`; mãos têm pivô em
`(225, 225)` e não ultrapassam o canvas. As posições inferiores evitam a
borda curva e preservam espaço negativo.

Tipografia: `SYNC_TO_DEVICE`, peso `NORMAL`; hora Digital `82 px`, data
`18–20 px` e bateria `20–22 px`. Não incluir fonte externa.

## 5. Mapeamento WFF 2

| Elemento visual | Construção WFF 2 | Recurso/expressão | Comportamento dinâmico |
| --- | --- | --- | --- |
| Fundo | `Scene` | `backgroundColor="#FF000000"` | constante |
| Estilo | `ListConfiguration` + `Condition` | opções `0` Digital e `1` Analógico | reavalia e seleciona um único grupo no mesmo APK |
| Hora Digital | `DigitalClock`/`TimeText` | `hh:mm`, `SYNC_TO_DEVICE` | acompanha formato 12/24 h do dispositivo |
| Data | `PartText` | `[DAY_OF_WEEK_S]`, `[DAY]`, `[MONTH_S]` | locale e calendário do sistema |
| Bateria | `PartText` | `round([BATTERY_PERCENT])` | `0%` a `100%`, sem provider externo |
| Marcadores | `ListConfiguration` e `PartDraw` | seis conjuntos originais e opção vazia | somente o grupo Analógico os revela |
| Horas/minutos | `AnalogClock` | `hour_hand`, `minute_hand` | rotação do sistema |
| Segundos | `AnalogClock` | `second_hand` | cor depende da intensidade; oculto em AOD |
| Cores | duas `ColorConfiguration` | `main_color`, `accent_color` | escolhas independentes |
| Intensidade | `ListConfiguration` | None, Discrete, Full | controla segundos e detalhes mínimos |

- Relógio: híbrido selecionável, com `CLOCK_TYPE="DIGITAL"` como estilo de
  preview e padrão.
- Data: Digital em `y=250`; Analógico em `y=298`.
- Ordem final: fundo, marcadores, relógio selecionado, textos secundários,
  realces de intensidade e pivô.
- Simplificações impostas pelo WFF 2: a configuração Markers não pode ser
  ocultada hierarquicamente no editor Digital e não há transição animada entre
  estilos. A hora Digital completa permanece na Main Color, sem sobreposição
  de Accent Color.
- Os usos de `accent_intensity` e `marker_style` ficam dentro dos grupos da
  `Condition`, nunca dentro do uso de outra configuração; isso evita o
  aninhamento não suportado e permite atualização imediata do estilo.

## 6. Complications

Essential não possui `ComplicationSlot`. A bateria usa diretamente
`[BATTERY_PERCENT]`; nenhum provider é fixado e nenhuma informação externa é
coletada ou configurável.

## 7. Configurações e paletas

### Main Color

| ID | Nome | Cor | Uso |
| ---: | --- | --- | --- |
| 0 | White | `#FFF5F5F5` | padrão; hora Digital e horas/minutos |
| 1 | Silver | `#FFC4C7CB` | alternativa neutra |
| 2 | Warm | `#FFE8C680` | branco quente discreto |
| 3 | Soft Green | `#FFC8DCA8` | verde claro dessaturado |

### Accent Color

| ID | Nome | Cor | Uso |
| ---: | --- | --- | --- |
| 0 | Green | `#FF5BD600` | padrão |
| 1 | Blue | `#FF4D8FE8` | alternativa azul |
| 2 | Orange | `#FFFF8500` | alternativa laranja |
| 3 | Purple | `#FF9A4DE0` | alternativa roxa |

Outras configurações:

- Style: Digital (`0`, padrão) e Analog (`1`).
- Accent Intensity: None (`0`), Discrete (`1`, padrão) e Full (`2`).
- Markers: Minimal (`0`, padrão), Short Ticks (`1`), Long Ticks (`2`),
  Small Dots (`3`), Dots (`4`), Hybrid (`5`) e None (`6`).
- None não desenha marcadores no modo interativo nem as quatro referências no
  AOD. Os IDs `0–5` foram preservados para não reinterpretar escolhas salvas.
- None mantém os segundos na Main Color; Discrete realça somente os segundos
  no Analógico e não altera a hora Digital; Full acrescenta quatro pontos
  cardinais de realce no Analógico e um ponto mínimo ao lado da bateria no
  Digital.
- Data e bateria usam cinza fixo `#FF9A9A9A`, nunca a cor de realce.

## 8. AOD

- Elementos mantidos no Digital: hora completa na Main Color e bateria.
- Elementos mantidos no Analógico: horas, minutos, bateria e quatro referências
  cardinais mínimas, exceto quando Markers estiver em None.
- Elementos ocultos: data em ambos, segundos, marcadores secundários e detalhes
  Full.
- Redução de brilho/alpha: hora/mãos `145–160`, bateria `105–120`, marcadores
  cardinais `80–95`.
- Estratégia contra excesso de pixels acesos: fundo preto puro, sem escala
  completa no AOD, sem segundos e sem superfícies preenchidas grandes.
- Legibilidade mínima: a identidade Digital/Analógica e a hora permanecem
  inequívocas; bateria é secundária e pode ser revista após teste físico.

## 9. Assets e licenças

| Asset | Fonte editável | Recurso no APK | Autoria/licença | Processo de geração |
| --- | --- | --- | --- | --- |
| Preview Digital | `shared-source/artwork/essential/preview.svg` | `faces/essential/src/main/res/drawable-nodpi/preview.png` | criação original, GPL-3.0-only | SVG manual → PNG 450 × 450 |
| Ponteiro de horas | `shared-source/artwork/essential/hour_hand.svg` | `faces/essential/src/main/res/drawable-nodpi/hour_hand.png` | criação original, GPL-3.0-only | SVG manual transparente → PNG |
| Ponteiro de minutos | `shared-source/artwork/essential/minute_hand.svg` | `faces/essential/src/main/res/drawable-nodpi/minute_hand.png` | criação original, GPL-3.0-only | SVG manual transparente → PNG |
| Ponteiro de segundos | `shared-source/artwork/essential/second_hand.svg` | `faces/essential/src/main/res/drawable-nodpi/second_hand.png` | criação original, GPL-3.0-only | SVG manual transparente → PNG |

Elementos que devem ser recriados por risco de propriedade intelectual:
carcaça do relógio, composição promocional, controles ilustrativos e qualquer
fonte não identificada do mockup.

## 10. Acessibilidade e localização

- todos os nomes de configurações e opções são localizáveis em inglês e
  português do Brasil;
- contraste mínimo visual alto sobre preto em todas as Main Colors;
- estilo e informação não dependem somente de cor;
- fonte do sistema e tamanhos mínimos de `18 px` para conteúdo secundário;
- data segue locale do dispositivo, sem texto estático não traduzido no visor;
- o editor expõe Markers também no Digital por limitação documentada do WFF 2.

## 11. Prompt normalizado para o Codex

```text
Leia MASTER_SPEC.md, docs/REFERENCE_TO_SPEC.md e
docs/watchfaces/ESSENTIAL.md por completo. Implemente Essential como um novo
módulo em faces/essential/, usando package ID
com.rtosta.wearfaces.essential, WFF 2 e API 34.

Use docs/watchfaces/ESSENTIAL.md como fonte de verdade. Em um único APK,
ofereça Style Digital/Analog por ListConfiguration e selecione a cena por
Condition, sem aninhar usos de configurações. Use canvas 450 x 450,
fundo AMOLED preto, fonte SYNC_TO_DEVICE, somente hora, data e
BATTERY_PERCENT. Não crie ComplicationSlot. O Digital usa hora grande `hh:mm`
integralmente em Main Color, sem Accent Color nos minutos.
O Analógico usa mãos originais estreitas, segundos como realce e sete opções
de marcadores. Implemente Main Color, Accent Color, Accent Intensity
None/Discrete/Full e Markers conforme a especificação. A opção Markers pode
permanecer visível no editor Digital porque hierarquia condicional não pertence
ao baseline WFF 2.

No AOD, preserve o estilo: Digital mantém hora e bateria; Analógico mantém
horas/minutos, bateria e quatro referências cardinais quando Markers não for
None. Oculte data, segundos,
realces e marcadores secundários. Produza assets originais em
shared-source/artwork/essential/ e seus PNGs no módulo; não incorpore o mockup
ou a carcaça.

Crie/atualize faces/essential/, README principal, settings.gradle.kts,
documentação, validações, release, roadmap e CHANGELOG.md. Preserve o pacote
resource-only, android:hasCode="false", offline e sem classes.dex. Execute
./tools/dev.sh test e o build específico; registre testes físicos como
pendentes se não forem realmente executados.

Não objetivos: rede, telemetria, dados de saúde, complications, WFF posterior,
renderer legado, efeitos decorativos e alegações não medidas de economia.
```

## 12. Critérios de aceite

- [x] especificação validada antes da implementação;
- [x] WFF 2/API 34 e `android:hasCode="false"`;
- [x] package ID e módulo independentes;
- [x] Digital e Analógico no mesmo APK;
- [x] hora, data e bateria conforme especificação;
- [x] nenhuma complication;
- [x] Main Color, Accent Color e três intensidades;
- [x] sete opções de marcadores analógicos, incluindo Nenhum;
- [x] AOD próprio preservando o estilo;
- [x] assets originais/licenciados;
- [x] Android Lint e schema WFF aprovados;
- [x] memory footprint aprovado;
- [x] APK debug produzido e sem `classes.dex`;
- [x] README, changelog e documentação sincronizados.

## 13. Testes físicos pendentes

Até execução real no Xiaomi Watch 2, permanecem pendentes: instalação, picker,
Digital/Analógico e persistência da alternância; horários Digital `00:00`,
`01:01`, `08:08`, `10:08`, `11:11`, `12:59`, `20:00`, `23:59`; horários
Analógicos `00:00`, `03:15`, `06:30`, `09:45`, `10:08`, `12:30`, `18:30`,
`23:59`; bateria de `0%` a `100%`; sete opções de marcadores; todas as cores e
intensidades; entrada/saída do AOD; clipping, brilho, reboot, troca/retorno e
atualização/reinstalação. A adequação dos marcadores à carcaça física também
depende dessa avaliação.
