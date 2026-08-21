# Diretrizes de design

## Legibilidade e AMOLED

Use preto real como fundo, contraste suficiente e informação essencial dentro
da área segura circular. Teste ponteiros sobre todas as cores e complications
vazias. Elementos decorativos não podem competir com a hora.

## AOD e eficiência

O modo ambiente deve remover halos/animações, reduzir pixels acesos e manter
horas/minutos inequívocos. Prefira primitivas, vetores pequenos e reutilização;
valide os limites oficiais de 10 MB ambiente e 100 MB interativo.

## Configuração e acessibilidade

Paletas precisam de nomes localizáveis e diferenças perceptíveis. Slots devem
ter nomes claros, bounds tocáveis e comportamento útil sem provider. Use fontes
do sistema quando possível e não dependa apenas de cor para informação crítica.

## Assets e propriedade intelectual

Crie geometria e arte originais. Não extraia APKs, firmware, imagens, fontes ou
ícones proprietários. Registre autoria/licença no diretório-fonte; copie para
`res/` apenas o artefato necessário e otimizado.

Dados de saúde, clima, agenda ou atividade vêm exclusivamente de complications
compatíveis escolhidas pelo usuário. O mostrador não coleta dados, não usa rede
e não inclui telemetria.
