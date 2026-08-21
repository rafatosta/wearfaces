# Aurora — especificação Sunlight

## 1. Identidade e proveniência

- Nome: `Aurora`
- Slug: `aurora`
- Package ID: `com.rtosta.wearfaces.aurora`
- Estado: `implementado`
- Tipo de referência: `nenhuma referência externa incorporada`
- Origem/autoria da referência: conceito original do WearFaces
- Autorização/licença: código e assets próprios sob GPL-3.0-only
- Referência será commitada: não aplicável

“Sunlight” é o nome interno desta especificação visual. Aurora traduz luz
difusa e fenômenos atmosféricos em um dial AMOLED original; não reproduz um
mostrador ou asset de fabricante.

## 2. Leitura da referência

### Observado

Não houve foto ou mockup externo usado como fonte de geometria. O requisito
inicial definiu um mostrador analógico AMOLED com luz difusa, data, paletas,
duas complications e AOD.

### Inferido

- luz difusa poderia ser representada eficientemente por elipses concêntricas;
- quatro marcadores cardinais seriam suficientes para orientar o dial;
- slots laterais preservariam o centro para os ponteiros.

### Decidido para a criação original

- halo verde-água abstrato como configuração padrão;
- ponteiros vetoriais originais rasterizados para PNG compatível com WFF;
- ausência de ponteiro de segundos para reduzir distração e custo ambiente;
- complications laterais sem provider fixo.

### Incertezas materiais

Nenhuma para o MVP. Refinamentos após teste físico devem atualizar primeiro
esta especificação.

## 3. Intenção e não objetivos

### Intenção

Criar uma leitura analógica serena e imediata, com o preto AMOLED dominando a
composição e um núcleo luminoso que mude de caráter conforme a paleta.

### Não objetivos

- copiar imagens, fontes, ícones ou geometria de mostradores comerciais;
- oferecer ponteiro de segundos, animações complexas ou rede;
- coletar telemetria ou dados próprios de saúde;
- elevar WFF 2, API 34 ou o baseline Wear OS 5.

## 4. Especificação visual

Canvas WFF: `450 × 450`; centro: `(225, 225)`.

| Camada | Elemento | X | Y | Largura | Altura | Aparência/comportamento |
| ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | Fundo | 0 | 0 | 450 | 450 | preto AMOLED sólido |
| 2 | Halo externo | 70 | 70 | 310 | 310 | cor de destaque, alpha 32 |
| 3 | Halos internos | 105 | 105 | 240 | 240 | três elipses progressivamente luminosas |
| 4 | Marcadores | 28–422 | 28–422 | variável | variável | quatro marcas cardinais arredondadas |
| 5 | Data | 150 | 315 | 150 | 42 | dia e mês curto, centralizados |
| 6 | Complication esquerda | 55 | 171 | 106 | 106 | slot circular 100 |
| 7 | Complication direita | 289 | 171 | 106 | 106 | slot circular 101 |
| final | Ponteiros e eixo | 0 | 0 | 450 | 450 | sempre acima dos demais elementos |

A área segura é circular. Os ponteiros usam pivôs próximos à extremidade
inferior de seus bitmaps e o conteúdo informativo permanece afastado da borda.
A tipografia usa `SYNC_TO_DEVICE`.

## 5. Mapeamento WFF 2

| Elemento visual | Construção WFF 2 | Recurso/expressão | Comportamento dinâmico |
| --- | --- | --- | --- |
| Halo | `Group` + `PartDraw` + `Ellipse` | `CONFIGURATION.palette` | oculto em `AMBIENT` |
| Marcadores | `RoundRectangle` | cor primária | alpha reduzido em `AMBIENT` |
| Data | `PartText` + `Template` | `[DAY]`, `[MONTH_S]` | alpha reduzido em `AMBIENT` |
| Slots | `ComplicationSlot` | slots 100 e 101 | ocultos em `AMBIENT` |
| Hora | `AnalogClock` | `hour_hand`, `minute_hand` | alpha reduzido em `AMBIENT` |

- Relógio: analógico.
- Data: `%02d %s`, abaixo do eixo.
- Mãos e eixo aparecem por último para preservar legibilidade.
- Luz difusa é aproximada com primitivas WFF, sem shader, código ou WFF novo.

## 6. Complications

| Nome | Slot ID | X | Y | Largura | Altura | Tipos suportados | Estado `EMPTY` |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| Esquerda | 100 | 55 | 171 | 106 | 106 | `SHORT_TEXT MONOCHROMATIC_IMAGE EMPTY` | não desenha conteúdo |
| Direita | 101 | 289 | 171 | 106 | 106 | `SHORT_TEXT MONOCHROMATIC_IMAGE EMPTY` | não desenha conteúdo |

Nenhum provider é fixado. Passos, saúde, clima e agenda dependem exclusivamente
da escolha do usuário.

## 7. Configurações e paletas

| ID | Nome | Primária | Secundária | Destaque | Atenuada | Uso |
| ---: | --- | --- | --- | --- | --- | --- |
| 0 | Solar | `#FFFFB347` | `#FFFF6B35` | `#FFFFD166` | `#FF704525` | âmbar e laranja |
| 1 | Nebula | `#FFC8A2FF` | `#FF7457FF` | `#FFFF7AE5` | `#FF3D315F` | violeta e magenta |
| 2 | Aurora | `#FF9BFFE8` | `#FF21D4A7` | `#FF67F5C8` | `#FF17483E` | verde-água; padrão |
| 3 | Mono | `#FFFFFFFF` | `#FFB8B8B8` | `#FFE0E0E0` | `#FF3A3A3A` | escala de cinza |

Não há outras configurações no MVP.

## 8. AOD

- mantém ponteiros, eixo, data e marcadores cardinais;
- oculta halo e complications;
- reduz marcadores para alpha 105, ponteiros para 190 e data para 150;
- não possui ponteiro de segundos nem animação;
- mantém fundo preto e poucos pixels acesos.

## 9. Assets e licenças

| Asset | Fonte editável | Recurso no APK | Autoria/licença | Processo de geração |
| --- | --- | --- | --- | --- |
| Ponteiro de horas | `shared-source/artwork/aurora/hour_hand.svg` | `drawable-nodpi/hour_hand.png` | WearFaces/GPL-3.0-only | rasterização transparente |
| Ponteiro de minutos | `shared-source/artwork/aurora/minute_hand.svg` | `drawable-nodpi/minute_hand.png` | WearFaces/GPL-3.0-only | rasterização transparente |
| Preview | `shared-source/artwork/aurora/preview.svg` | `drawable-nodpi/preview.png` | WearFaces/GPL-3.0-only | rasterização 450 × 450 |

Não há elementos proprietários a reproduzir.

## 10. Acessibilidade e localização

- paletas e slots possuem nomes em recursos Android;
- ponteiros mantêm contraste contra preto e halo;
- a hora não depende somente de cor;
- data e complication usam fonte sincronizada com o dispositivo;
- novas traduções devem cobrir todos os nomes configuráveis em conjunto.

## 11. Prompt normalizado para o Codex

```text
Leia MASTER_SPEC.md, docs/REFERENCE_TO_SPEC.md e
docs/watchfaces/SUNLIGHT.md. Mantenha ou evolua o Aurora no módulo
faces/aurora/, package ID com.rtosta.wearfaces.aurora, WFF 2 e API 34.

Use SUNLIGHT.md como fonte de verdade para canvas 450 × 450, ordem das camadas,
coordenadas, quatro paletas, slots 100/101, AOD e assets. Preserve o design
original, resource-only, android:hasCode="false", offline e sem telemetria.

Atualize primeiro a especificação quando mudar a direção visual. Sincronize
WFF, fontes SVG, recursos finais, README, testes e CHANGELOG.md. Execute
./tools/dev.sh test e gere o APK debug. Não declare testes físicos como
aprovados sem o Xiaomi Watch 2.

Não objetivos: copiar ativos comerciais, adicionar renderer legado, rede,
telemetria, ponteiro de segundos ou elevar o baseline.
```

## 12. Critérios de aceite

- [x] especificação persistida;
- [x] WFF 2/API 34 e `android:hasCode="false"`;
- [x] package ID e módulo independentes;
- [x] hora analógica e data;
- [x] duas complications com estado vazio;
- [x] quatro paletas;
- [x] AOD próprio;
- [x] assets originais/licenciados;
- [x] Android Lint e schema WFF aprovados;
- [x] memory footprint aprovado;
- [x] APK debug produzido;
- [x] README, changelog e documentação sincronizados.

## 13. Testes físicos pendentes

Permanecem pendentes no Xiaomi Watch 2: instalação e picker; 00:00, 03:15,
06:30, 09:45 e 12:00; virada da data; complications vazias/configuradas; quatro
paletas; entrada e saída do AOD; clipping; reboot; troca/retorno; atualização e
reinstalação.
