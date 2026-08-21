# Stride — especificação

## 1. Identidade e proveniência

- Nome: `Stride`
- Slug: `stride`
- Package ID: `com.rtosta.wearfaces.stride`
- Estado: `implementado; validação física pendente`
- Tipo de referência: `mockup`
- Origem/autoria da referência: mockup `stride.png` fornecido pelo mantenedor e
  instruções complementares em `PROMPT_CODEX_STRIDE.md`; autoria e licença dos
  elementos gráficos da imagem não foram comprovadas.
- Autorização/licença: autorizado somente como referência conceitual para esta
  criação original.
- Referência será commitada: `não`

## 2. Leitura da referência

### Observado

- mostrador digital esportivo circular com fundo preto e alta densidade de
  informações;
- passos e uma barra de progresso no topo, data curta, hora grande no centro e
  três células circulares na metade inferior;
- arcos coloridos periféricos nas regiões superior esquerda e inferior;
- quatro famílias de cores denominadas Lime, Ocean, Sunset e Purple;
- modo AOD preto, dessaturado e mais simples que o modo interativo;
- ícones de tênis, coração, localização, chama e raio ajudam a identificar os
  dados no mockup.

### Inferido

- cores, coordenadas, tipografia, pesos e espessuras abaixo são aproximações,
  pois a imagem não é um artefato executável;
- a barra superior parece representar uma meta de passos e os arcos inferiores
  parecem representar bateria;
- não é possível comprovar pela imagem os providers, metas, formatos 12/24 h,
  comportamento acima de 100% ou regras de atualização.

### Decidido para a criação original

- preservar a hierarquia esportiva, o alto contraste e a distribuição
  simétrica, mas redesenhar toda a geometria com primitivas WFF e fonte do
  sistema;
- não usar o logotipo, lettering, fonte ou ícones do mockup;
- sincronizar a notação de 12/24 horas com a preferência do dispositivo por
  `hourFormat="SYNC_TO_DEVICE"`;
- criar um slot superior editável para passos/progresso, três slots esportivos
  editáveis e um slot inferior editável com bateria como padrão;
- manter distância e calorias sem provider padrão, pois não há um default de
  sistema WFF 2 portável para esses dados;
- normalizar e limitar arcos de progresso entre 0% e 100%, incluindo valores
  acima da meta e ranges inválidos.

### Incertezas materiais

- validação de dimensões, cores, consumo e legibilidade em relógio físico;
- disponibilidade de providers de distância e calorias no dispositivo do
  usuário;
- representação visual da notação de 12 horas em diferentes localidades, a
  confirmar em hardware físico.

## 3. Intenção e não objetivos

### Intenção

Criar um mostrador digital esportivo focado em leitura rápida durante treino:
hora dominante, atividade diária no topo, três dados configuráveis equilibrados
e bateria claramente identificável, com cor reservada para progresso e foco.

### Não objetivos

- não copiar fontes, ícones, logotipos, imagens ou geometria proprietária;
- não reproduzir ou apresentar Stride como produto de terceiro;
- não elevar WFF/API;
- não adicionar código executável, rede, telemetria ou coleta própria de saúde;
- não acessar sensores ou Health Connect diretamente;
- não criar tema claro ou animações por segundo no MVP.

## 4. Especificação visual

Canvas WFF: `450 × 450`; centro: `(225, 225)`.

| Camada | Elemento | X | Y | Largura | Altura | Aparência/comportamento |
| ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | Fundo | 0 | 0 | 450 | 450 | Preto AMOLED puro `#FF000000` |
| 2 | Escala periférica | 0 | 0 | 450 | 450 | 24 marcas curtas, cinza e discretas; marca das 12h na cor primária |
| 3 | Progresso de passos | 55 | 28 | 340 | 82 | slot superior com ícone/texto central e arco de 260 graus quando o provider expuser progresso |
| 4 | Data | 120 | 111 | 210 | 30 | dia da semana, dia e mês em caixa alta visual e cor primária |
| 5 | Hora | 45 | 142 | 360 | 104 | hora digital `hh:mm`, branca, grande, centralizada e sincronizada com a preferência 12/24 h do dispositivo |
| 6 | Pulso de movimento | 147 | 244 | 156 | 24 | linha original com pequeno zigue-zague central, apenas decorativa |
| 7 | Slot esportivo esquerdo | 48 | 279 | 110 | 110 | padrão frequência cardíaca; círculo fino e conteúdo centralizado |
| 8 | Slot esportivo central | 170 | 292 | 110 | 110 | padrão vazio; indicado para distância |
| 9 | Slot esportivo direito | 292 | 279 | 110 | 110 | padrão vazio; indicado para calorias |
| 10 | Bateria | 99 | 388 | 252 | 49 | slot horizontal com porcentagem e arcos inferiores dinâmicos |

Área segura, clipping e pivôs: conteúdo textual essencial fica dentro do
círculo de raio `195`; somente escala e arcos decorativos alcançam a região
periférica. Slots circulares possuem margem interna mínima de `8 px` e seus
conteúdos não se sobrepõem à hora.

Tipografia: `SYNC_TO_DEVICE`; peso `BOLD` para a hora, `MEDIUM` para valores e
`NORMAL` para data e textos auxiliares. Tamanhos-alvo: `82 px` para hora,
`27–31 px` para valores e `15–19 px` para data/conteúdo compacto.

## 5. Mapeamento WFF 2

| Elemento visual | Construção WFF 2 | Recurso/expressão | Comportamento dinâmico |
| --- | --- | --- | --- |
| Fundo | `Scene` | `backgroundColor="#FF000000"` | igual em todos os modos |
| Escala | `PartDraw`/`Group` | retângulos rotacionados | oculta em `AMBIENT` |
| Data | `PartText` | `[DAY_OF_WEEK_S]`, `[DAY]`, `[MONTH_S]` | calendário e localidade do sistema |
| Hora | `DigitalClock`/`TimeText` | `hh:mm`, `hourFormat="SYNC_TO_DEVICE"` | relógio do sistema, atualização por minuto e preferência 12/24 h do dispositivo |
| Progresso superior | `ComplicationSlot` | `GOAL_PROGRESS`, `RANGED_VALUE`, `SHORT_TEXT` | arcos normalizados e limitados a 100% |
| Dados esportivos | três `ComplicationSlot` | conteúdo do provider | usuário escolhe providers disponíveis |
| Bateria | `ComplicationSlot` | `WATCH_BATTERY`/`RANGED_VALUE` | porcentagem e arcos normalizados |
| Pulso central | `PartDraw` | linhas originais | decorativo, oculto em `AMBIENT` |

- Relógio: `digital`
- Data: `EEE, d MMM`, obtida do sistema e posicionada acima da hora.
- Ordem final: fundo, escala, slots/progressos, data, hora e pulso decorativo.
- Simplificações impostas pelo WFF 2: sem fonte condensada proprietária,
  gradientes, sombras, brilho, animação contínua ou ícones esportivos fixos.

## 6. Complications

| Nome | Slot ID | X | Y | Largura | Altura | Tipos suportados | Padrão e estado `EMPTY` |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| Atividade superior | 300 | 55 | 28 | 340 | 82 | `SHORT_TEXT`, `MONOCHROMATIC_IMAGE`, `RANGED_VALUE`, `GOAL_PROGRESS`, `EMPTY` | `STEP_COUNT`/`SHORT_TEXT`; vazio deixa somente a trilha discreta |
| Esportivo esquerdo | 301 | 48 | 279 | 110 | 110 | `SHORT_TEXT`, `MONOCHROMATIC_IMAGE`, `RANGED_VALUE`, `GOAL_PROGRESS`, `EMPTY` | `HEART_RATE`/`SHORT_TEXT`; vazio mantém contorno |
| Esportivo central | 302 | 170 | 292 | 110 | 110 | mesmos tipos | vazio; indicado para distância; vazio mantém contorno |
| Esportivo direito | 303 | 292 | 279 | 110 | 110 | mesmos tipos | vazio; indicado para calorias; vazio mantém contorno |
| Bateria inferior | 304 | 99 | 388 | 252 | 49 | `SHORT_TEXT`, `MONOCHROMATIC_IMAGE`, `RANGED_VALUE`, `GOAL_PROGRESS`, `EMPTY` | `WATCH_BATTERY`/`RANGED_VALUE`; vazio deixa trilha inferior discreta |

Nenhum dado é coletado pelo mostrador. Os defaults de passos, frequência
cardíaca e bateria apenas selecionam providers de sistema portáveis; todos os
slots permanecem editáveis. Distância e calorias dependem de providers
compatíveis instalados e escolhidos pelo usuário.

Nos tipos `GOAL_PROGRESS`, o progresso é
`clamp(value / target, 0, 1)` quando `target > 0`. Nos tipos `RANGED_VALUE`, é
`clamp((value - min) / (max - min), 0, 1)` quando `max > min`. Range ou meta
inválida resulta em arco sem preenchimento. Valores continuam legíveis mesmo
quando o ícone não é fornecido.

## 7. Configurações e paletas

| ID | Nome | Primária | Secundária | Destaque | Atenuada | Uso |
| ---: | --- | --- | --- | --- | --- | --- |
| 0 | Lime | `#FFB7F000` | `#FF78A900` | `#FFF4F7ED` | `#FF3B4430` | padrão; progresso, data e focos |
| 1 | Ocean | `#FF22B8F4` | `#FF147ACB` | `#FFF2F7FA` | `#FF29404A` | variação azul de alto contraste |
| 2 | Sunset | `#FFFF6A20` | `#FFFFB13B` | `#FFFFF3EA` | `#FF4E392E` | variação laranja e âmbar |
| 3 | Purple | `#FFC66BFF` | `#FF7A5CFF` | `#FFF8F0FF` | `#FF453550` | variação roxa e violeta |

Outras configurações: cinco escolhas independentes de complication. A hora
segue a preferência 12/24 h do dispositivo; não há opção visual sem semântica
funcional.

## 8. AOD

- Elementos mantidos: fundo preto, data, hora e conteúdo textual atenuado dos
  slots superior e de bateria;
- Elementos ocultos: escala, arcos, pulso decorativo e três slots esportivos;
- Redução de brilho/alpha: hora `170`, data `120` e dados mantidos `110`;
- Estratégia contra excesso de pixels acesos: preto puro, ausência de áreas
  preenchidas e de animação por segundo, visando permanecer abaixo de 15% do
  canvas aceso; a confirmação visual permanece pendente no hardware;
- Legibilidade mínima: hora e data continuam distinguíveis; passos e bateria
  são secundários e podem desaparecer quando o provider estiver vazio.

## 9. Assets e licenças

| Asset | Fonte editável | Recurso no APK | Autoria/licença | Processo de geração |
| --- | --- | --- | --- | --- |
| Preview | `shared-source/artwork/stride/preview.svg` | `faces/stride/src/main/res/drawable-nodpi/preview.png` | criação original, GPL-3.0-only | composição vetorial manual e exportação SVG → PNG |
| Visor | nenhum | `faces/stride/src/main/res/raw/watchface.xml` | criação original, GPL-3.0-only | primitivas WFF e fonte do sistema |

Elementos que devem ser recriados por risco de propriedade intelectual:
logotipo “S”, lettering Stride, fonte digital condensada e os cinco ícones do
mockup. A imagem de referência e o documento anexado não integram o repositório.

## 10. Acessibilidade e localização

- nomes de paletas e slots localizáveis em inglês e português do Brasil;
- contraste alto sobre preto em todas as paletas;
- valores e posições distinguem a informação sem depender somente de cor;
- fonte do sistema e valores grandes reduzem dependência de assets tipográficos;
- data segue a localidade do dispositivo;
- conteúdo textual continua centralizado quando não houver ícone do provider.

## 11. Prompt normalizado para o Codex

```text
Leia MASTER_SPEC.md, docs/REFERENCE_TO_SPEC.md e docs/watchfaces/STRIDE.md por
completo. Implemente Stride como um novo módulo em faces/stride/, usando package
ID com.rtosta.wearfaces.stride, WFF 2 e API 34.

Use docs/watchfaces/STRIDE.md como fonte de verdade para composição 450 × 450,
camadas, coordenadas, paletas, complications, AOD e assets. Produza um design
original; não copie logotipo, fonte, ícones ou outros recursos proprietários da
referência. Mantenha o pacote resource-only, android:hasCode="false", offline e
sem telemetria.

Implemente hora digital sincronizada com a preferência 12/24 h do dispositivo,
data localizada, slot superior de atividade com passos como padrão, três slots
esportivos editáveis e slot inferior com bateria como padrão. Distância e
calorias começam vazias e dependem de providers instalados. Normalize
progressos, limite os arcos a 100% e trate metas/ranges inválidos. Ofereça Lime,
Ocean, Sunset e Purple. No AOD, mantenha apenas hora, data e texto atenuado de
atividade/bateria, ocultando arcos e slots esportivos.

Crie/atualize faces/stride/, shared-source/artwork/stride/, README principal,
settings.gradle.kts, documentação, testes e CHANGELOG.md. Execute
./tools/dev.sh test e gere o APK debug. Informe separadamente tudo que depender
de hardware físico.

Não objetivos específicos: tema claro, acesso direto a sensores/Health
Connect, animação por segundo, reprodução de marca/arte da referência e suporte
anterior ao Wear OS 5.
```

## 12. Critérios de aceite

- [x] especificação validada antes da implementação;
- [x] WFF 2/API 34 e `android:hasCode="false"`;
- [x] package ID e módulo independentes;
- [x] hora digital e data conforme especificação;
- [x] cinco complications editáveis e estados vazios seguros;
- [x] progressos reais, normalizados e limitados a 100%;
- [x] quatro paletas;
- [x] AOD próprio sem arcos e sem os três slots esportivos;
- [x] assets originais/licenciados;
- [x] Android Lint e schema WFF aprovados;
- [x] memory footprint aprovado;
- [x] APK debug produzido;
- [x] README, changelog e documentação sincronizados.

## 13. Testes físicos pendentes

Registrar como pendentes até execução real: instalação, seleção no picker,
horários de referência, virada da data, progresso abaixo/em/acima da meta,
ranges inválidos, ausência de ícones, complications vazias/configuradas,
providers de distância/calorias, quatro paletas, entrada e saída do AOD,
burn-in/clipping, reboot, troca/retorno e atualização/reinstalação.
