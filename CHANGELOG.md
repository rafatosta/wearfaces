# Changelog

Todas as mudanças relevantes do WearFaces devem ser registradas neste
arquivo.

## [Unreleased]

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

### Fixed

-   Corrigida a construção da imagem Podman ao reutilizar o UID/GID 1000 já
    presente na base Temurin, com `HOME` gravável e referência completa ao
    registry oficial.
