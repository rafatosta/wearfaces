# <NOME DO MOSTRADOR> — especificação

> Copie este arquivo para `docs/watchfaces/<NOME>.md`, remova estas instruções e
> substitua todos os marcadores. Não implemente o módulo enquanto decisões
> materiais permanecerem indefinidas.

## 1. Identidade e proveniência

- Nome: `<nome>`
- Slug: `<slug>`
- Package ID: `com.rtosta.wearfaces.<slug>`
- Estado: `rascunho | aprovado | implementado`
- Tipo de referência: `foto | screenshot | desenho | mockup | nenhuma`
- Origem/autoria da referência: `<origem>`
- Autorização/licença: `<como a referência pode ser usada>`
- Referência será commitada: `não | sim, com justificativa e licença`

## 2. Leitura da referência

### Observado

- `<característica diretamente visível>`

### Inferido

- `<estimativa ou comportamento não comprovado pela imagem>`

### Decidido para a criação original

- `<adaptação autorizada e implementável>`

### Incertezas materiais

- `<decisão pendente ou “nenhuma”>`

## 3. Intenção e não objetivos

### Intenção

`<experiência, hierarquia e atmosfera pretendidas>`

### Não objetivos

- não copiar fontes, ícones, logotipos, imagens ou geometria proprietária;
- não elevar WFF/API;
- não adicionar rede, telemetria ou coleta própria de saúde;
- `<outros limites do mostrador>`.

## 4. Especificação visual

Canvas WFF: `450 × 450`; centro: `(225, 225)`.

| Camada | Elemento | X | Y | Largura | Altura | Aparência/comportamento |
| ---: | --- | ---: | ---: | ---: | ---: | --- |
| 1 | Fundo | 0 | 0 | 450 | 450 | `<preto AMOLED e efeitos>` |
| 2 | `<elemento>` | `<x>` | `<y>` | `<w>` | `<h>` | `<descrição>` |
| final | Hora | `<x>` | `<y>` | `<w>` | `<h>` | `<descrição>` |

Área segura, clipping e pivôs: `<definição>`.

Tipografia: `<SYNC_TO_DEVICE ou fonte licenciada, tamanhos e pesos>`.

## 5. Mapeamento WFF 2

| Elemento visual | Construção WFF 2 | Recurso/expressão | Comportamento dinâmico |
| --- | --- | --- | --- |
| `<elemento>` | `<PartDraw/PartText/...>` | `<nome ou expressão>` | `<Variant/Transform/...>` |

- Relógio: `analógico | digital | híbrido`
- Data: `<formato, expressão e posição>`
- Ordem final de mãos/complications: `<decisão de camadas>`
- Simplificações impostas pelo WFF 2: `<efeitos adaptados>`

## 6. Complications

| Nome | Slot ID | X | Y | Largura | Altura | Tipos suportados | Estado `EMPTY` |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `<slot>` | `<id>` | `<x>` | `<y>` | `<w>` | `<h>` | `<tipos>` | `<comportamento>` |

Nenhum provider é fixado. Dados vêm exclusivamente de providers escolhidos
pelo usuário.

## 7. Configurações e paletas

| ID | Nome | Primária | Secundária | Destaque | Atenuada | Uso |
| ---: | --- | --- | --- | --- | --- | --- |
| 0 | `<nome>` | `#AARRGGBB` | `#AARRGGBB` | `#AARRGGBB` | `#AARRGGBB` | `<uso>` |
| 1 | `<nome>` | `#AARRGGBB` | `#AARRGGBB` | `#AARRGGBB` | `#AARRGGBB` | `<uso>` |
| 2 | `<nome>` | `#AARRGGBB` | `#AARRGGBB` | `#AARRGGBB` | `#AARRGGBB` | `<uso>` |

Outras configurações: `<opções ou “nenhuma”>`.

## 8. AOD

- Elementos mantidos: `<lista>`
- Elementos ocultos: `<lista>`
- Redução de brilho/alpha: `<valores>`
- Estratégia contra excesso de pixels acesos: `<decisão>`
- Legibilidade mínima: `<hora/data mantidas>`

## 9. Assets e licenças

| Asset | Fonte editável | Recurso no APK | Autoria/licença | Processo de geração |
| --- | --- | --- | --- | --- |
| `<asset>` | `shared-source/artwork/<slug>/...` | `faces/<slug>/src/main/res/...` | `<licença>` | `<conversão>` |

Elementos que devem ser recriados por risco de propriedade intelectual:
`<lista ou “nenhum”>`.

## 10. Acessibilidade e localização

- nomes de paletas e slots localizáveis;
- contraste e leitura em todas as paletas;
- informação crítica não depende somente de cor;
- fonte/tamanho: `<decisões>`;
- strings e idiomas iniciais: `<decisões>`.

## 11. Prompt normalizado para o Codex

```text
Leia MASTER_SPEC.md, docs/REFERENCE_TO_SPEC.md e esta especificação por
completo. Implemente <NOME> como um novo módulo em faces/<slug>/, usando package
ID com.rtosta.wearfaces.<slug>, WFF 2 e API 34.

Use esta especificação como fonte de verdade para composição 450 × 450,
camadas, coordenadas, paletas, complications, AOD e assets. Produza um design
original; não copie recursos proprietários da referência. Mantenha o pacote
resource-only, android:hasCode="false", offline e sem telemetria.

Crie/atualize faces/<slug>/, shared-source/artwork/<slug>/, README principal,
settings.gradle.kts, documentação, testes e CHANGELOG.md. Execute
./tools/dev.sh test e gere o APK debug. Informe separadamente tudo que depender
de hardware físico.

Não objetivos específicos: <lista>.
Decisões materiais já tomadas: <resumo autocontido>.
```

## 12. Critérios de aceite

- [ ] especificação validada antes da implementação;
- [ ] WFF 2/API 34 e `android:hasCode="false"`;
- [ ] package ID e módulo independentes;
- [ ] hora e data conforme especificação;
- [ ] complications e estado vazio;
- [ ] três ou mais paletas, quando aplicável;
- [ ] AOD próprio;
- [ ] assets originais/licenciados;
- [ ] Android Lint e schema WFF aprovados;
- [ ] memory footprint aprovado;
- [ ] APK debug produzido;
- [ ] README, changelog e documentação sincronizados.

## 13. Testes físicos pendentes

Registrar como pendentes até execução real: instalação, picker, horários de
referência, virada da data, complications vazias/configuradas, paletas, entrada
e saída do AOD, clipping, reboot, troca/retorno e atualização/reinstalação.
