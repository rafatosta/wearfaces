# Changelog

Todas as mudanças relevantes do WearFaces devem ser registradas neste
arquivo.

## [Unreleased]

### Added

-   Adicionados template e gerador de módulos, CLI unificada, diagnóstico do
    host e ambiente containerizado separado para Wear OS 5/API 34 com KVM,
    Wayland/X11 e modo headless.

### Changed

-   Atualizados `compileSdk` e `targetSdk` para 35, preservando `minSdk 34` e
    WFF 2, e centralizada a configuração Android comum em convention plugin.
-   Movidos ADB, instalação, preview, APK e AAB para o fluxo oficial
    containerizado, mantendo Android Studio e SDK/JDK/Gradle opcionais no host.

## [0.1.0] - 2026-08-21

### Added

-   Definida a arquitetura monorepo para múltiplos mostradores WFF.
-   Definido WFF 2 / Wear OS 5 / API 34 como baseline.
-   Definido Podman como ambiente oficial e reproduzível de build e
    testes.
-   Definido fluxo de ADB por Wi-Fi no host Fedora para instalação no
    relógio.
-   Definidos testes locais, validação WFF, CI e workflow de releases.
-   Definida política de Conventional Commits e validação de mensagens
    na CI.
-   Definida política obrigatória de manutenção do changelog.
-   Definida GPL-3.0 como licença do código.
-   Definido Semantic Versioning coordenado para o monorepo, iniciando
    em 0.1.0.
-   Definido **Aurora** como primeiro mostrador.
-   Adicionadas políticas de assinatura persistente, compatibilidade e
    avaliação de testes visuais.
-   Criado o monorepo Gradle funcional com wrapper 9.1.0 e AGP 9.0.0.
-   Implementado o Aurora WFF 2 com data, quatro paletas, duas complications e
    modo AOD dedicado.
-   Adicionados scripts executáveis para validação, testes, builds, checksums,
    commits convencionais e instalação segura via ADB.
-   Adicionado ambiente Podman pinado com Android SDK e validadores WFF
    oficiais, além dos workflows de CI e release assinada.
-   Criadas a documentação permanente, templates de contribuição e política de
    assets originais/licenciados.
-   Adicionado template obrigatório e fluxo auditável para converter fotos ou
    mockups em especificações e prompts implementáveis pelo Codex.
-   Adicionada a especificação do mostrador **Flow**, extraída de mockup, com
    quatro paletas, duas complications, AOD e limites explícitos para identidade
    e assets GNOME.
-   Implementado o mostrador **Flow** como módulo WFF 2 independente, com data
    superior, quatro paletas, três complications configuráveis, segundos e AOD
    otimizado.
-   Adicionada a especificação e implementação do **Essential**, um módulo WFF
    2 independente que alterna entre estilos Digital e Analógico no mesmo APK,
    com bateria direta, duas famílias de cores, três intensidades, sete opções
    de marcadores — incluindo Nenhum —, quatro campos radiais editáveis sem
    aro ou provider padrão e AOD próprio.

### Changed

-   Padronizado o nome definitivo do projeto como **WearFaces**.
-   Padronizado o repositório como `wearfaces`.
-   Padronizado o namespace base como `com.rtosta.wearfaces`.
-   Padronizado o primeiro package ID como
    `com.rtosta.wearfaces.aurora`.
-   Removidos nomes provisórios/incorretos AirFace, RFace e namespaces
    derivados de erros de transcrição.
-   Adotado Build Tools 36.0.0 por exigência do AGP 9.0.0, preservando API 34 e
    WFF 2 como baseline de execução.
-   Ampliada a validação documental para abranger também especificações de
    mostradores ainda não vinculadas a um módulo Gradle.
-   Generalizada a validação estática e oficial WFF para conferir todos os
    módulos de mostrador, em vez de somente o Aurora.
-   Generalizada a validação de relógio para aceitar módulos digitais com
    `DigitalClock`/`TimeText` e módulos analógicos com ponteiros completos.
-   Tornada a regra de complications consciente do contrato de cada mostrador,
    exigindo no **Essential** seus quatro slots radiais.
-   Redesenhados os ponteiros de hora e minuto do **Flow** com corpo claro,
    extremidade externa arredondada e afilamento em direção ao pivô, conforme o
    mockup aprovado.
-   Tornada obrigatória uma mensagem Conventional Commit sugerida em toda
    resposta final do Codex que suceda modificações em arquivos do repositório.
-   Refinado o **Flow** com fundo AMOLED preto puro, índices usando toda a borda,
    remoção do glifo e três complications editáveis; passos e bateria são
    defaults portáveis, enquanto calorias dependem de provider instalado.
-   Ampliadas em aproximadamente 20% a hora e a data do Digital e a data do
    Analógico no **Essential**, removendo também o ponto de realce ao lado da
    bateria Digital.
-   Ampliados os ponteiros analógicos do **Essential** e deslocados todos os
    marcadores para o limite útil da tela; segundos alcançam a escala, minutos
    mantêm folga e horas preservam a proporção.
-   Reorganizados os campos editáveis do **Essential** em quatro posições
    diagonais: dois alinhados às direções dos botões físicos à direita e dois
    espelhados à esquerda, todos compactos, vazios por padrão e sem aro.
-   Revisados e reexportados os previews de **Aurora**, **Essential** e
    **Flow** para refletir horários, geometria, opacidades e configurações
    atuais; adicionada uma galeria dos três mostradores ao README principal.

### Fixed

-   Corrigida a inicialização do emulador containerizado com registro do pacote
    Emulator no SDK, dependência nativa `libxkbfile1`, listener compatível com
    ADB 37, diretório persistente explícito do AVD, preservação dos logs quando
    um contêiner encerra durante o boot e diagnóstico da regressão KVM dos
    kernels 7.1.0–7.1.10 do Fedora 44.
-   Corrigidos os workflows de CI e release ao instalar `xmllint` nos runners
    Ubuntu, indicar explicitamente o `Containerfile` no build Docker e executar
    a suíte em uma cópia gravável do checkout dentro do contêiner.
-   Corrigida a alternância Digital/Analógico do **Essential** ao substituir o
    uso aninhado de configurações por uma `Condition` reativa ao estilo.
-   Removida a camada de Accent Color dos minutos do **Essential**, mantendo a
    hora Digital integralmente na Main Color.
-   Sincronizado o preview do **Flow** com as dimensões, posições, opacidades e
    intervalos dos pontos e índices externos definidos no XML WFF.
-   Persistida a chave de assinatura debug em um volume Podman dedicado,
    evitando assinaturas diferentes entre builds executados em contêineres
    efêmeros.
-   Centralizado o conteúdo das três complications do **Flow** nos dois eixos,
    restaurando o arranjo de ícone sobre texto e a porcentagem da bateria.
-   Ocultados completamente os três slots e seus anéis no modo AOD do **Flow**.
-   Reforçada a ocultação dos aros do **Flow** no AOD diretamente em cada
    elemento gráfico, sem depender apenas da transparência herdada pelo grupo.
-   Removido do AOD do **Flow** o anel externo completo de pontos e índices,
    mantendo somente data e ponteiros de hora/minuto sobre o fundo preto.
-   Corrigida a construção da imagem Podman ao reutilizar o UID/GID 1000 já
    presente na base Temurin, com `HOME` gravável e referência completa ao
    registry oficial.
-   Corrigido o avanço e retorno perceptível do ponteiro de segundos do
    **Flow**, substituindo o impulso discreto por varredura contínua a 15 Hz.
