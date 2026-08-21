# Flow — especificação

## 1. Identidade e proveniência

- Nome: `Flow`
- Slug: `flow`
- Package ID: `com.rtosta.wearfaces.flow`
- Estado: `implementado com identidade provisória Flow`
- Tipo de referência: `mockup`
- Origem/autoria da referência: mockup fornecido pelo mantenedor no anexo
  `59a62ee0-e2d7-478a-8fbe-25a125079947.png`; autoria não comprovada.
- Autorização/licença: autorizado somente como referência visual nesta análise;
  a licença de redistribuição do mockup e a autorização para usar nome, logotipo
  ou ícones GNOME não foram demonstradas.
- Referência será commitada: `não`

O mantenedor forneceu posteriormente um glifo Flow formado por dois arcos
orgânicos e dois círculos, em gradiente azul, sobre base quadrada arredondada
azul-marinho. Ele está aprovado como identidade provisória para implementar e
avaliar o mostrador. O arquivo entregue serve como referência: para o APK, o
glifo deve ser reconstruído em fonte editável e exportado com transparência,
sem incorporar a base quadrada ou o fundo preto da imagem.

O nome e o logotipo GNOME não podem integrar o APK enquanto não houver
autorização escrita da GNOME Foundation e registro da licença/proveniência. Uma
eventual substituição do glifo Flow pela marca GNOME será uma decisão posterior
e não bloqueia a implementação atual.

## 2. Leitura da referência

### Observado

- mostrador analógico circular, escuro, com vinheta radial discreta;
- logotipo no topo, data textual logo abaixo e um segundo bloco de data às 6h;
- ponteiros de hora e minuto brancos, largos e afilados, ponteiro de segundos
  fino na cor de destaque e pivô central circular;
- 60 marcas periféricas, com índices de hora maiores e um ponto colorido às 12h;
- duas complications circulares: passos à esquerda e clima à direita;
- quatro variações de destaque: azul, verde, roxo e laranja;
- modo AOD preto, dessaturado e com menos brilho;
- um conjunto de quatro pequenos pontos próximo às 6h, sem função explicada;
- a referência adicional do glifo mostra dois arcos orgânicos e dois círculos
  com gradiente azul, sobre uma base quadrada arredondada azul-marinho.

### Inferido

- coordenadas, espessuras e cores abaixo são estimativas sobre a imagem, não
  medidas de um produto executável;
- os anéis parciais das complications parecem decorativos, e não progresso;
- o bloco inferior parece ser data interna, e não uma terceira complication;
- a fonte exata, os providers, a semântica dos quatro pontos e a animação dos
  elementos não podem ser determinados pelo mockup.

### Decidido para a criação original

- preservar a hierarquia, o contraste, a grade circular e as quatro famílias
  cromáticas, mas redesenhar todos os recursos gráficos;
- substituir o logotipo superior pelo glifo Flow provisório fornecido pelo
  mantenedor, redesenhado como asset transparente adequado ao mostrador;
- usar ícones monocromáticos fornecidos pelo provider nas complications, sem o
  ícone de pegada GNOME mostrado no exemplo;
- omitir os quatro pontos inferiores no MVP, pois não há função comprovada;
- usar fundo AMOLED escuro em todas as paletas; as paletas alteram apenas
  destaques, anéis, segundos e pivô.

### Incertezas materiais

- autorização escrita para nome, logotipo e ícones GNOME, somente caso o
  mantenedor decida usá-los posteriormente no lugar da identidade Flow;
- confirmação da autoria e da licença de redistribuição do glifo fornecido antes
  de uma publicação; isso não impede um build local de avaliação;
- validação das estimativas de cor e dimensão em relógio físico;
- confirmação de que a redundância entre a data superior e inferior é desejada.

## 3. Intenção e não objetivos

### Intenção

Criar um mostrador analógico leve, sóbrio e legível, com simetria clara: data no
eixo vertical, duas informações configuráveis nas laterais e cor usada apenas
como orientação visual. O resultado deve remeter a simplicidade e consistência,
sem reproduzir a identidade de terceiros.

### Não objetivos

- não copiar fontes, ícones, logotipos, imagens ou geometria proprietária;
- não apresentar Flow como produto oficial, afiliado ou endossado pelo GNOME;
- não elevar WFF/API;
- não adicionar rede, telemetria ou coleta própria de saúde;
- não fixar steps ou weather como providers;
- não oferecer tema claro no MVP.

## 4. Especificação visual

Canvas WFF: `450 × 450`; centro: `(225, 225)`.

| Camada | Elemento | X | Y | Largura | Altura | Aparência/comportamento |
| ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | Fundo | 0 | 0 | 450 | 450 | Preto `#FF05080D`, com gradiente radial até `#FF172230`; sem textura |
| 2 | Escala periférica | 22 | 22 | 406 | 406 | 60 índices; 12 barras maiores e 48 pontos atenuados; ponto das 12h na primária |
| 3 | Glifo Flow | 196 | 42 | 58 | 54 | Dois arcos e dois círculos do símbolo provisório, sem base; versão clara centralizada |
| 4 | Data superior | 120 | 101 | 210 | 40 | Dia da semana, dia e mês em uma linha, destaque claro |
| 5 | Complication esquerda | 50 | 170 | 118 | 118 | Anel fino; ícone, valor e rótulo do provider centralizados |
| 6 | Complication direita | 282 | 170 | 118 | 118 | Espelhada em relação ao eixo vertical |
| 7 | Data inferior | 171 | 305 | 108 | 108 | Anel fino, dia grande e mês abreviado abaixo |
| 8 | Pivô | 210 | 210 | 30 | 30 | Disco primário com centro claro e contorno secundário |
| final | Hora | 0 | 0 | 450 | 450 | Ponteiros acima de textos e complications; segundos acima de hora/minuto e abaixo do pivô |

Área segura, clipping e pivôs: conteúdo essencial fica dentro do círculo de
raio `203`; as três células circulares não podem interceptar os índices. Todos
os ponteiros giram em `(225, 225)`. Complications recortam seu conteúdo em um
círculo inscrito com margem interna mínima de `10 px`.

Tipografia: `SYNC_TO_DEVICE`, peso normal para rótulos e data, peso semibold
para valores; tamanhos-alvo de `18–22 px` para rótulos, `30–34 px` para valores
e `42 px` para o dia inferior. Ajustar apenas após teste de clipping no schema e
em hardware.

## 5. Mapeamento WFF 2

| Elemento visual | Construção WFF 2 | Recurso/expressão | Comportamento dinâmico |
| --- | --- | --- | --- |
| Fundo | `PartDraw` | círculo sólido e gradiente radial simples | gradiente oculto em `AMBIENT` |
| Índices | `PartDraw` repetido | linhas/pontos vetoriais nas 60 posições | cor vinculada à paleta; alpha reduzido em AOD |
| Glifo Flow | `PartImage` | PNG gerado de SVG original | versão monocromática atenuada em AOD |
| Data superior | `PartText` | `[DAY_OF_WEEK_S]`, `[DAY]`, `[MONTH_S]` | atualização pelo calendário do sistema |
| Data inferior | `PartText` | `[DAY]` e `[MONTH_S]` | dois tamanhos no círculo inferior |
| Células laterais | `ComplicationSlot` | slots `200` e `201` | conteúdo escolhido pelo usuário |
| Anéis | `PartDraw` | arco/anel decorativo, sem representar progresso | cores por `ColorConfiguration` |
| Ponteiros | `AnalogClock` | PNGs originais para hora, minuto e segundos | segundos em varredura contínua a 15 Hz e ocultos em `AMBIENT` |

- Relógio: `analógico`
- Data: `EEE, d MMM` no topo e `d`/`MMM` no círculo inferior, respeitando a
  localidade do dispositivo.
- Ordem final de mãos/complications: fundo, índices, marca, data, anéis,
  complications, data inferior, hora, minuto, segundos e pivô.
- Simplificações impostas pelo WFF 2: substituir sombras e efeitos fotográficos
  por gradiente e contornos simples; não reproduzir reflexos metálicos do mockup.

## 6. Complications

| Nome | Slot ID | X | Y | Largura | Altura | Tipos suportados | Estado `EMPTY` |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| Esquerda | 200 | 50 | 170 | 118 | 118 | `SHORT_TEXT`, `MONOCHROMATIC_IMAGE`, `RANGED_VALUE`, `GOAL_PROGRESS`, `EMPTY` | manter apenas o anel decorativo, sem placeholder textual |
| Direita | 201 | 282 | 170 | 118 | 118 | `SHORT_TEXT`, `MONOCHROMATIC_IMAGE`, `RANGED_VALUE`, `GOAL_PROGRESS`, `EMPTY` | manter apenas o anel decorativo, sem placeholder textual |

Nenhum provider é fixado. Dados vêm exclusivamente de providers escolhidos
pelo usuário. “Passos” e “clima” são exemplos do mockup, não defaults nem dados
coletados pelo mostrador.

## 7. Configurações e paletas

As cores são aproximações visuais e devem ser calibradas em hardware.

| ID | Nome | Primária | Secundária | Destaque | Atenuada | Uso |
| ---: | --- | --- | --- | --- | --- | --- |
| 0 | Azul | `#FF4A9BFF` | `#FF215A96` | `#FFEAF3FF` | `#FF31465F` | padrão; segundos, pivô, ponto das 12h e anéis |
| 1 | Verde | `#FF54D56B` | `#FF237A36` | `#FFE8FFE9` | `#FF2D4B33` | mesmos elementos da paleta padrão |
| 2 | Roxo | `#FFC06BFF` | `#FF71369B` | `#FFF6E9FF` | `#FF493451` | mesmos elementos da paleta padrão |
| 3 | Laranja | `#FFFF8A32` | `#FFA64A16` | `#FFFFEDDF` | `#FF593B2A` | mesmos elementos da paleta padrão |

Outras configurações: duas escolhas independentes de complication. Não expor
opções cuja função seja somente imitar os quatro pontos indefinidos do mockup.

## 8. AOD

- Elementos mantidos: fundo preto, índices de hora, glifo Flow, data superior,
  hora/minuto, data inferior e conteúdo atual das duas complications;
- Elementos ocultos: gradiente, pontos de minuto intermediários, ponteiro de
  segundos e efeitos de destaque;
- Redução de brilho/alpha: textos e ponteiros em cinza `#FF8A8F96`; anéis,
  glifo e complications com alpha máximo aproximado de `35%`;
- Estratégia contra excesso de pixels acesos: fundo totalmente preto, traços
  finos, remoção de gradiente e dos 48 pontos menores, sem animação por segundo;
- Legibilidade mínima: hora/minuto e data superior permanecem distinguíveis; a
  informação das complications é secundária e pode ser mais atenuada.

## 9. Assets e licenças

| Asset | Fonte editável | Recurso no APK | Autoria/licença | Processo de geração |
| --- | --- | --- | --- | --- |
| Glifo Flow | `shared-source/artwork/flow/flow-glyph.svg` | `faces/flow/src/main/res/drawable-nodpi/flow_glyph.png` | referência fornecida pelo mantenedor; autoria/licença de publicação pendentes | reconstrução vetorial dos dois arcos e dois círculos; exportação SVG → PNG transparente |
| Ponteiros | `shared-source/artwork/flow/hour_hand.svg`, `minute_hand.svg` e `second_hand.svg` | `faces/flow/src/main/res/drawable-nodpi/*_hand.png` | criação original, GPL-3.0-only | exportação determinística SVG → PNG transparente |
| Preview | `shared-source/artwork/flow/preview.svg` | `faces/flow/src/main/res/drawable-nodpi/preview.png` | composição original GPL-3.0-only; componente do glifo com licença de publicação pendente | composição a partir dos assets aprovados |
| Índices e anéis | nenhum | construídos no XML WFF | criação original, GPL-3.0-only | primitivas WFF, sem bitmap externo |

Elementos que devem ser recriados por risco de propriedade intelectual:
logotipo e nome GNOME, pegada usada como ícone de passos, fonte não identificada
e desenho exato dos ponteiros/ícones do mockup. O glifo Flow deve ser redesenhado
em SVG, preservando a forma fornecida, mas removendo a base quadrada e o fundo
preto. Mesmo com autorização para a marca GNOME, os termos dessa autorização
precisam acompanhar a proveniência do asset.

## 10. Acessibilidade e localização

- nomes de paletas e slots localizáveis;
- contraste e leitura em todas as paletas;
- informação crítica não depende somente de cor;
- fonte/tamanho: usar fonte do sistema, valores com pelo menos `30 px` no canvas
  450 e rótulos com pelo menos `18 px`, sem condensação automática ilegível;
- strings e idiomas iniciais: inglês e português do Brasil; formatos de data
  vêm da localidade, sem strings de calendário fixas;
- ícones de complications são acompanhados por valor textual quando o provider
  fornecer ambos; a cor não altera o significado dos dados.

## 11. Prompt normalizado para o Codex

```text
Leia MASTER_SPEC.md, docs/REFERENCE_TO_SPEC.md e docs/watchfaces/FLOW.md por
completo. Implemente Flow como um novo módulo em faces/flow/, usando package ID
com.rtosta.wearfaces.flow, WFF 2 e API 34.

Implemente com a identidade provisória Flow aprovada nesta especificação. Não
use nome, logotipo, ícone de pegada ou outros assets GNOME sem autorização
escrita e licença registradas. Reconstrua o glifo Flow fornecido como SVG
editável composto por dois arcos orgânicos e dois círculos; exporte para PNG com
fundo transparente e não inclua a base quadrada do arquivo de referência.

Use esta especificação como fonte de verdade para composição 450 × 450,
camadas, coordenadas, paletas, complications, AOD e assets. Mantenha o pacote
resource-only, android:hasCode="false", offline e sem telemetria. Não fixe
providers de passos ou clima e não trate os quatro pontos inferiores do mockup
como requisito funcional.

Crie/atualize faces/flow/, shared-source/artwork/flow/, README principal,
settings.gradle.kts, documentação, testes e CHANGELOG.md. Execute
./tools/dev.sh test e gere o APK debug. Informe separadamente tudo que depender
de hardware físico.

Não objetivos específicos: tema claro, rede, telemetria, coleta própria de
saúde, cópia da identidade GNOME ou reprodução fotográfica do mockup.
Decisões materiais já tomadas: duas complications configuráveis, data superior
e inferior, quatro paletas de destaque, fundo sempre escuro, identidade Flow
provisória aprovada para avaliação, omissão dos quatro pontos indefinidos e
segundos ocultos no AOD. A eventual adoção da marca GNOME fica fora desta
implementação e será decidida somente após a avaliação do mostrador pronto.
```

## 12. Critérios de aceite

- [x] especificação validada antes da implementação;
- [x] identidade provisória Flow confirmada para implementação e avaliação;
- [x] WFF 2/API 34 e `android:hasCode="false"`;
- [x] package ID e módulo independentes;
- [x] hora e data conforme especificação;
- [x] complications e estado vazio;
- [x] quatro paletas;
- [x] AOD próprio;
- [ ] assets originais/licenciados;
- [ ] autoria/licença do glifo formalizada antes de distribuição pública;
- [x] Android Lint e schema WFF aprovados;
- [x] memory footprint aprovado;
- [x] APK debug produzido;
- [x] README, changelog e documentação sincronizados.

## 13. Testes físicos pendentes

Permanecem pendentes até execução em relógio físico: instalação, picker,
horários de referência (00:00, 03:15, 06:30, 09:45 e 12:00), virada da data,
localidades pt-BR/en, complications vazias e configuradas, quatro paletas,
entrada e saída do AOD, clipping em tela circular, brilho/legibilidade, reboot,
troca/retorno de mostrador e atualização/reinstalação.
