# Aurora — especificação Sunlight

## Conceito

Aurora traduz luz difusa e fenômenos atmosféricos em um dial AMOLED original.
“Sunlight” é o nome interno desta especificação visual, não uma reprodução de
mostrador ou asset de fabricante.

## Composição 450 × 450

- fundo preto e halo concêntrico difuso no centro;
- marcadores cardinais esparsos;
- ponteiros de horas e minutos originais, sempre acima do conteúdo;
- data curta na região inferior;
- complications configuráveis à esquerda (slot 100) e direita (slot 101).

Slots aceitam `SHORT_TEXT`, `MONOCHROMATIC_IMAGE` e `EMPTY`. Nenhum provider é
fixado; passos, saúde, clima e agenda dependem da escolha do usuário.

## Paletas

Solar (âmbar/laranja), Nebula (violeta/magenta), Aurora (verde-água) e Mono.
Aurora é o padrão. Todas alteram ponteiros, halo, data e complications.

## AOD

Remove halo e complications, reduz marcadores e brilho dos ponteiros/data. A
hora permanece legível com poucos pixels acesos. Não há ponteiro de segundos.

## Aceite físico

Além da suíte automatizada, executar integralmente a matriz de
`docs/TESTING.md` no Xiaomi Watch 2. Screenshots e resultados permanecem
pendentes até esse teste.
