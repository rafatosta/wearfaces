# Da referência visual à especificação

Este documento define como o Codex deve transformar foto, screenshot, desenho
ou mockup em uma especificação implementável pelo WearFaces. A imagem nunca
substitui `docs/watchfaces/<NOME>.md`.

## Contrato

Antes de alterar Gradle, WFF, assets ou documentação de um novo módulo, o Codex
deve copiar [o template](watchfaces/TEMPLATE.md), preenchê-lo e vinculá-lo no
README do módulo. A ordem obrigatória é:

```text
referência → análise → especificação → prompt normalizado → implementação
```

Se a solicitação autorizar tanto especificação quanto implementação e não
houver ambiguidade material, o Codex pode executar as etapas na mesma tarefa,
mas deve persistir a especificação antes do código. Se uma decisão mudar
layout, dados, interação, licença ou compatibilidade, deve pedir orientação.

## 1. Entrada e proveniência

Registrar quem forneceu a referência, qual é o tipo de arquivo, se ela deve ser
apenas inspiração ou reprodução autorizada e quais direitos existem sobre seus
elementos. Não commitar anexos automaticamente.

Uma foto de produto ou screenshot pode mostrar material protegido. Nesses
casos, extrair somente conceitos abstratos autorizados — hierarquia, equilíbrio,
contraste, densidade e atmosfera — e criar geometria, ícones, fontes e assets
originais.

## 2. Leitura visual auditável

Separar a análise em três grupos:

- **Observado:** conteúdo visível diretamente, como posições relativas, tipo de
  relógio, quantidade de elementos e relações de contraste.
- **Inferido:** estimativas, como cor aproximada, tipografia aparente, dimensões
  e comportamento que uma imagem estática não comprova.
- **Decidido:** adaptação original escolhida para WFF 2, incluindo coordenadas,
  formatos de complication, AOD e substituição de elementos proprietários.

Não descrever como fato algo que só foi inferido. Usar valores aproximados até
que o mantenedor escolha ou a implementação seja medida.

## 3. Tradução para WFF

Normalizar a referência num canvas 450 × 450, centro `(225, 225)`. Definir a
ordem das camadas, bounds, pivôs, área segura circular e comportamento ambiente.
Para cada elemento, indicar a construção WFF 2 prevista (`PartDraw`,
`PartText`, `AnalogClock`, `DigitalClock`, `ComplicationSlot`, `Group` ou asset).

Efeitos impossíveis ou dispendiosos devem ser simplificados sem WFF 3/4,
renderer legado, rede ou código executável. Dados externos entram somente por
complications escolhidas pelo usuário.

## 4. Prompt normalizado

A especificação deve conter um prompt autocontido para uma futura sessão do
Codex. Ele deve citar o arquivo da especificação como fonte de verdade e conter:

- resultado esperado e identidade;
- baseline WFF 2/minSdk 34, targetSdk 35 e package ID;
- composição, coordenadas e ordem das camadas;
- paletas, complications e AOD;
- ativos a criar e limites de propriedade intelectual;
- arquivos a modificar;
- não objetivos;
- critérios de aceite, testes e pendências físicas.

O prompt não deve depender de o Codex ainda enxergar a imagem original. A
especificação precisa carregar todas as decisões necessárias.

## 5. Gate antes da implementação

Antes de criar o módulo, confirmar:

- todos os campos relevantes do template foram preenchidos;
- incertezas materiais foram resolvidas ou claramente assumidas;
- referência e assets possuem uso autorizado;
- o design pode ser implementado em WFF 2/minSdk 34/targetSdk 35;
- há pelo menos três paletas quando personalização por cor fizer sentido;
- o AOD está definido;
- complications têm tipos, bounds e estado vazio;
- testes físicos continuam explicitamente pendentes.

Execute `./tools/validate-face-specs.sh`. Depois da implementação, execute
`./tools/dev.sh test`.

## 6. Revisões

Mudanças visuais posteriores atualizam primeiro a especificação, incluindo o
prompt normalizado e as decisões afetadas. Em seguida, sincronizam WFF, assets,
README, testes e `[Unreleased]` no changelog.
