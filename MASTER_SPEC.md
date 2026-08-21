# MASTER_SPEC.md --- WearFaces Repository Build Specification

> Este é o **documento mestre e fonte de verdade** para o Codex
> construir o repositório.\
> O Codex deve ler este arquivo integralmente antes de criar ou alterar
> qualquer artefato.

## 1. Objetivo

Construir um monorepo open source para uma coleção de mostradores Wear
OS usando **Watch Face Format (WFF)**.

Alvo inicial obrigatório:

-   Xiaomi Watch 2
-   Wear OS 5
-   Android API 34
-   WFF 2

O primeiro mostrador será **Aurora**, uma criação original inspirada
apenas na ideia de um mostrador AMOLED analógico com luz difusa. Não
copiar APKs, imagens, fontes, ícones, geometria ou outros ativos
proprietários da Xiaomi.

## 2. Regras arquiteturais

1.  O repositório é único.
2.  Cada mostrador é um módulo Android independente em `faces/<slug>/`.
3.  Cada módulo produz seu próprio APK/AAB.
4.  Variações do mesmo design --- cores, estilos e complications ---
    pertencem ao mesmo módulo quando WFF 2 permitir.
5.  Pacotes WFF são resource-only e devem usar
    `android:hasCode="false"`.
6.  Não usar Jetpack Watch Face renderer legado.
7.  Não usar WFF 3 ou 4 no baseline.
8.  Não usar Watch Face Push no baseline, pois o alvo é Wear OS 5/API
    34. 
9.  Não elevar `minSdk` ou versão WFF sem decisão explícita documentada.
10. Não adicionar dependências sem necessidade concreta.

## 3. Árvore obrigatória

O Codex deve criar e manter esta organização:

``` text
weawearfacess/
├── MASTER_SPEC.md
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CHANGELOG.md
├── settings.gradle.kts
├── build.gradle.kts
├── gradle.properties
├── gradlew
├── gradlew.bat
├── gradle/
│   ├── libs.versions.toml
│   └── wrapper/
│
├── faces/
│   └── aurora/
│       ├── README.md
│       ├── build.gradle.kts
│       └── src/
│           └── main/
│               ├── AndroidManifest.xml
│               └── res/
│                   ├── drawable/
│                   ├── raw/
│                   │   └── watchface.xml
│                   ├── values/
│                   └── xml/
│                       └── watch_face_info.xml
│
├── shared-source/
│   ├── artwork/
│   │   └── aurora/
│   ├── icons/
│   └── fonts/
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DEVELOPMENT.md
│   ├── TESTING.md
│   ├── DESIGN_GUIDELINES.md
│   ├── RELEASE.md
│   ├── ROADMAP.md
│   └── watchfaces/
│       └── SUNLIGHT.md
│
├── tools/
│   ├── build-all.sh
│   ├── validate.sh
│   ├── test.sh
│   ├── install.sh
│   └── checksums.sh
│
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── bug.yml
    │   └── watchface-request.yml
    ├── pull_request_template.md
    └── workflows/
        ├── ci.yml
        └── release.yml
```

Ao adicionar um segundo mostrador, por exemplo `minimal`, criar:

``` text
faces/minimal/
shared-source/artwork/minimal/
docs/watchfaces/MINIMAL.md
```

Não criar um novo diretório geral de documentação para cada mostrador.

## 4. Documentação oficial

Antes da implementação, verificar a documentação oficial atual:

-   WFF: https://developer.android.com/training/wearables/wff
-   Setup WFF:
    https://developer.android.com/training/wearables/wff/setup
-   Samples:
    https://github.com/android/wear-os-samples/tree/main/WatchFaceFormat
-   Ferramentas/validadores: https://github.com/google/watchface
-   Watch Face Push, apenas para compreender a limitação:
    https://developer.android.com/training/wearables/watch-face-push

Se esta especificação divergir de uma exigência técnica atual da
documentação oficial, seguir a documentação oficial e registrar a
divergência em `docs/ARCHITECTURE.md`.

## 5. Primeiro mostrador: Aurora

Package ID sugerido:

``` text
com.rtof.weawearfacess.aurora
```

### Requisitos

-   mostrador analógico;
-   ponteiro de horas;
-   ponteiro de minutos;
-   data;
-   fundo preto adequado a AMOLED;
-   halo/gradiente luminoso original;
-   pelo menos duas complications configuráveis;
-   pelo menos três paletas;
-   modo AOD próprio;
-   funcionamento sem rede;
-   nenhuma telemetria;
-   nenhuma coleta própria de saúde.

Dados como passos, frequência cardíaca, clima ou agenda devem vir de
complications/providers compatíveis quando disponíveis.

### Direção visual

Temas iniciais:

-   Solar;
-   Nebula;
-   Aurora;
-   Mono.

O AOD deve reduzir elementos decorativos e pixels acesos, mantendo a
hora legível.

## 6. Documentos que o Codex deve gerar

### `README.md`

Vitrine do projeto, incluindo:

-   propósito;
-   screenshots quando existirem;
-   compatibilidade;
-   lista de mostradores;
-   build;
-   testes;
-   instalação ADB;
-   releases;
-   contribuição.

### `docs/ARCHITECTURE.md`

Registrar:

-   por que monorepo;
-   um módulo/APK por mostrador;
-   baseline WFF 2/API 34;
-   estratégia de módulos;
-   package IDs;
-   política para versões futuras.

### `docs/DEVELOPMENT.md`

Documentar ambiente local, Android SDK/JDK, Gradle, comandos de build e
fluxo de desenvolvimento.

### `docs/TESTING.md`

Ser a referência completa dos testes locais e CI.

### `docs/DESIGN_GUIDELINES.md`

Regras compartilhadas de legibilidade, AMOLED, AOD, assets,
acessibilidade e propriedade intelectual.

### `docs/watchfaces/SUNLIGHT.md`

Especificação exclusiva do Aurora. Todo novo mostrador deve possuir um
arquivo equivalente.

### `docs/RELEASE.md`

Versionamento, assinatura, secrets, artifacts, checksums e procedimento
de release.

### `docs/ROADMAP.md`

Planejamento incremental.

### `CONTRIBUTING.md`

Como criar um novo módulo, testar e submeter PR.

### `CHANGELOG.md`

Usar formato consistente e manter mudanças relevantes.

## 7. Build local

O repositório deve oferecer, no mínimo:

``` bash
./gradlew assembleDebug
./gradlew :faces:aurora:assembleDebug
./tools/build-all.sh
```

O Codex deve executar os comandos possíveis no ambiente em que estiver
trabalhando e corrigir falhas antes de concluir.

## 8. Estratégia de testes

Testes não devem ser tratados apenas como documentação. O projeto deve
possuir verificações executáveis.

### 8.1 Testes/verificações locais obrigatórios

`tools/test.sh` deve executar, quando aplicável:

1.  validação da estrutura do repositório;
2.  Gradle checks;
3.  validação XML;
4.  validação WFF oficial;
5.  verificação de manifests;
6.  confirmação de `android:hasCode="false"`;
7.  confirmação da versão WFF esperada;
8.  confirmação de `minSdk`;
9.  memory footprint validation oficial;
10. build debug de todos os módulos;
11. detecção de arquivos/ativos ausentes;
12. verificações adicionais que possam rodar sem relógio físico.

`tools/validate.sh` pode concentrar validadores estáticos;
`tools/test.sh` deve orquestrar a suíte local completa.

Todos os scripts devem:

``` bash
set -euo pipefail
```

ou comportamento equivalente, retornando código diferente de zero em
falha.

### 8.2 Testes de dispositivo

Documentar separadamente porque não podem ser simulados como "aprovados"
sem hardware.

No Xiaomi Watch 2 verificar:

-   instalação;
-   presença no picker;
-   seleção do mostrador;
-   00:00;
-   03:15;
-   06:30;
-   09:45;
-   12:00;
-   mudança de data;
-   complication vazia;
-   complications configuradas;
-   mudança de paleta;
-   entrada no AOD;
-   saída do AOD;
-   legibilidade;
-   clipping;
-   reinício do relógio;
-   troca para outro mostrador e retorno;
-   comportamento após atualização/reinstalação.

Nunca afirmar que esses testes passaram se não foram realmente
executados no dispositivo.

## 9. GitHub Actions --- CI

Criar `.github/workflows/ci.yml`.

Deve executar em push e pull request, pelo menos:

1.  checkout;
2.  configuração do JDK;
3.  configuração/caching Gradle apropriado;
4.  preparação do Android SDK quando necessária;
5.  `./tools/validate.sh`;
6.  `./tools/test.sh`;
7.  build dos módulos;
8.  upload dos APKs debug como artifacts quando o build passar.

A CI deve usar os mesmos scripts locais. Não duplicar toda a lógica
dentro do YAML.

O objetivo é:

``` text
desenvolvedor local
      │
      └── tools/test.sh
              │
              ├── validação
              ├── testes
              └── build

GitHub Actions
      │
      └── o mesmo tools/test.sh
```

Assim, o que passa localmente deve ser essencialmente o que a CI
verifica.

## 10. GitHub Actions --- Release

Criar `.github/workflows/release.yml`, acionado por tags adequadas.

Fluxo:

1.  checkout;
2.  ambiente Java/Android;
3.  suíte completa de testes;
4.  build release;
5.  assinatura;
6.  SHA-256;
7.  nomear artifacts de forma previsível;
8.  criar/anexar artifacts à GitHub Release.

Exemplo futuro:

``` text
aurora-1.0.0.apk
minimal-1.0.0.apk
digital-1.0.0.apk
activity-1.0.0.apk
classic-1.0.0.apk
SHA256SUMS
```

Keystore, alias e senhas nunca devem entrar no Git. Documentar os
secrets necessários.

## 11. Script ADB

`tools/install.sh` deve permitir instalar um módulo sem dados pessoais
hardcoded.

Exemplo conceitual:

``` text
./tools/install.sh aurora
```

e, quando necessário, aceitar o destino ADB explicitamente.

Deve verificar:

-   presença do `adb`;
-   dispositivo conectado;
-   existência do APK;
-   resultado da instalação.

## 12. Assets

`shared-source/` contém arquivos-fonte/editáveis e materiais de
trabalho.

`faces/<face>/src/main/res/` contém somente os recursos necessários ao
APK.

Todo asset deve ter origem/licença conhecida.

Não incluir material extraído de firmware Xiaomi, Google ou terceiros
sem autorização compatível.

## 13. Adição de novos mostradores

Todo novo mostrador exige:

1.  `faces/<slug>/`;
2.  package ID próprio;
3.  `faces/<slug>/README.md`;
4.  `shared-source/artwork/<slug>/`;
5.  `docs/watchfaces/<NOME>.md`;
6.  inclusão no README principal;
7.  inclusão automática ou explícita nos builds;
8.  validação local;
9.  CI verde.

Evitar copiar configuração Gradle desnecessariamente quando puder ser
centralizada sem violar as exigências do WFF.

## 14. Critérios de aceite do bootstrap

O bootstrap só está concluído quando:

-   árvore coerente criada;
-   Gradle Wrapper funcional;
-   Aurora compila;
-   scripts são executáveis;
-   validação local executada;
-   testes locais executados;
-   CI criada;
-   sintaxe dos workflows válida;
-   workflows usam os scripts locais;
-   documentação criada;
-   nenhum secret no repositório;
-   APK debug produzido;
-   falhas/limitações restantes documentadas.

## 15. Critérios de aceite do Aurora

Além do bootstrap:

-   WFF 2 válido;
-   API 34;
-   resource-only;
-   hora analógica funcional;
-   data;
-   duas complications;
-   três ou mais paletas;
-   AOD;
-   assets originais;
-   memory validation aprovada;
-   APK instalável gerado.

Testes físicos permanecem "pendentes" até execução real no Xiaomi Watch
2.

## 16. Procedimento obrigatório do Codex

Executar nesta ordem:

1.  Ler integralmente `MASTER_SPEC.md`.
2.  Consultar documentação oficial atual.
3.  Inspecionar o estado atual do repositório.
4.  Planejar a implementação.
5.  Criar a árvore base.
6.  Configurar Gradle.
7.  Criar o Aurora.
8.  Criar scripts.
9.  Criar documentação derivada.
10. Criar CI.
11. Criar workflow de release.
12. Executar validações.
13. Executar testes locais.
14. Executar builds.
15. Corrigir tudo que puder ser corrigido.
16. Reexecutar a suíte até ficar verde.
17. Não mascarar testes falhos.
18. Não remover validações apenas para obter CI verde.
19. Registrar testes dependentes de hardware como pendentes.
20. Entregar relatório final.

## 17. Relatório final esperado do Codex

Ao terminar, informar:

-   árvore criada;
-   arquivos principais;
-   versões escolhidas de Gradle/AGP/JDK;
-   versão WFF;
-   comandos executados;
-   testes executados;
-   resultados;
-   APKs produzidos;
-   workflows criados;
-   limitações;
-   testes físicos pendentes;
-   próximos passos.

## 18. Princípio de manutenção

Este arquivo permanece como a especificação mestre do projeto.

Quando uma decisão estrutural mudar, atualizar primeiro `MASTER_SPEC.md`
e depois sincronizar a documentação derivada pertinente.

A meta é que uma nova sessão do Codex possa receber apenas:

> Leia `MASTER_SPEC.md`, inspecione o repositório e implemente a próxima
> etapa respeitando integralmente a especificação.

e consiga compreender a arquitetura, os testes, a CI, a política de
releases e as restrições do projeto. \## 19. Fluxo de instalação no
relógio

O projeto deve oferecer `tools/install.sh` como fluxo principal de
desenvolvimento no dispositivo físico.

### Comportamento padrão

``` bash
./tools/install.sh aurora
```

Deve:

1.  verificar se `adb` está disponível;
2.  verificar se há dispositivo Wear OS conectado;
3.  recusar de forma clara se houver múltiplos dispositivos e nenhum
    destino tiver sido especificado;
4.  executar as validações necessárias;
5.  compilar o módulo solicitado;
6.  localizar o APK recém-gerado;
7.  instalar ou atualizar usando `adb install -r`;
8.  verificar o código de retorno;
9.  informar package ID, APK instalado e dispositivo de destino.

Também implementar, quando adequado:

``` bash
./tools/install.sh aurora --no-build
./tools/install.sh --all
```

`--no-build` reutiliza um APK já compilado. `--all` compila/instala
todos os módulos disponíveis.

O script não deve tentar desbloquear bootloader, usar Fastboot, alterar
firmware ou executar root.

O script também não deve depender de comandos internos não documentados
para tornar automaticamente o mostrador ativo. Após a instalação, o
usuário pode selecioná-lo pelo picker normal do Wear OS.

------------------------------------------------------------------------

## 20. Documentação permanente de ADB por Wi-Fi

Criar obrigatoriamente:

``` text
docs/ADB_WIFI.md
```

Esse documento deve ser autocontido. A finalidade é permitir que alguém
volte ao projeto meses depois e consiga conectar o Xiaomi Watch 2 ao
Fedora sem consultar fontes externas.

O `README.md` e `docs/DEVELOPMENT.md` devem apontar para
`docs/ADB_WIFI.md`.

### 20.1 Pré-requisitos no Fedora

O usuário normalmente já possui Android Studio/Android SDK Platform
Tools. Primeiro verificar:

``` bash
adb version
```

Se `adb` estiver no PATH, não instalar nada.

Se não estiver, documentar duas alternativas:

1.  localizar/utilizar o `adb` do Android SDK Platform Tools já
    instalado;
2.  opcionalmente instalar o pacote Fedora correspondente
    (`android-tools`) caso o usuário prefira o pacote do sistema.

Nunca exigir uma segunda instalação se o ADB funcional já existir.

### 20.2 Rede

Computador e relógio devem estar na mesma rede Wi-Fi e a rede precisa
permitir comunicação entre clientes.

Explicar que redes guest, corporativas ou com client/AP isolation podem
impedir a conexão.

### 20.3 Ativar opções de desenvolvedor no Watch 2

Documentar passo a passo, observando que nomes de menus podem variar
ligeiramente após atualizações:

1.  abrir Configurações;
2.  abrir Sistema/Sobre;
3.  localizar Número da versão/Build number;
4.  tocar repetidamente (normalmente sete vezes) até ativar modo
    desenvolvedor;
5.  retornar às Configurações;
6.  abrir Opções do desenvolvedor.

### 20.4 Ativar depuração

Nas Opções do desenvolvedor:

1.  ativar Depuração ADB, se apresentada;
2.  ativar Depuração sem fio/Wireless debugging;
3.  aceitar o aviso de segurança.

Recomendar uso somente em rede confiável e desativação quando não
estiver desenvolvendo.

### 20.5 Pareamento inicial

No relógio:

``` text
Opções do desenvolvedor
→ Depuração sem fio
→ Parear novo dispositivo / Pair new device
```

O relógio exibirá:

-   endereço IP;
-   porta de pareamento;
-   código temporário.

No Fedora:

``` bash
adb pair IP:PORTA_DE_PAREAMENTO
```

Exemplo meramente ilustrativo:

``` bash
adb pair 192.168.1.50:37123
```

Quando solicitado, digitar o código mostrado no relógio.

Documentar explicitamente:

> A porta usada em `adb pair` é a porta de pareamento e não deve ser
> presumida como sendo a porta usada posteriormente por `adb connect`.

### 20.6 Conexão

Depois do pareamento, retornar à tela principal de Wireless debugging e
localizar o endereço/porta destinados à conexão ADB.

Executar:

``` bash
adb connect IP:PORTA_DE_CONEXAO
```

Exemplo:

``` bash
adb connect 192.168.1.50:41987
```

Verificar:

``` bash
adb devices
```

Resultado esperado conceitualmente:

``` text
List of devices attached
192.168.1.50:41987    device
```

A partir desse momento, os scripts do WearFaces podem usar o relógio.

### 20.7 Verificar que é o dispositivo correto

Documentar comandos úteis:

``` bash
adb shell getprop ro.product.manufacturer
adb shell getprop ro.product.model
adb shell getprop ro.build.version.sdk
```

No alvo Wear OS 5 do projeto, a API esperada é 34.

### 20.8 Parear não significa conectar

Destacar uma seção de troubleshooting:

``` text
adb pair       → estabelece confiança entre computador e relógio
adb connect    → abre a sessão ADB usada pelos comandos
adb devices    → confirma a sessão ativa
```

É possível o pareamento estar correto e `adb devices` continuar vazio
porque `adb connect` ainda não foi executado.

### 20.9 Portas/IP podem mudar

Explicar que IP e especialmente portas de Wireless Debugging podem mudar
após:

-   desligar/religar Wi-Fi;
-   reiniciar o relógio;
-   desativar/reativar Wireless debugging;
-   mudanças na rede.

Nunca hardcode IP/porta do usuário no repositório.

### 20.10 Reconexão em sessões futuras

Se o computador continuar pareado:

1.  ativar Wireless debugging no relógio;
2.  consultar o endereço/porta atual;
3.  executar:

``` bash
adb connect IP:PORTA_ATUAL
adb devices
```

Em geral não é necessário executar `adb pair` novamente enquanto o
vínculo de pareamento permanecer salvo.

### 20.11 mDNS

Documentar opcionalmente que versões modernas do ADB podem descobrir
dispositivos pareados via mDNS. Incluir:

``` bash
adb mdns services
```

Porém não depender exclusivamente de descoberta automática: o
procedimento manual com `adb connect IP:PORTA` deve permanecer
documentado como fallback confiável.

### 20.12 Múltiplos dispositivos ADB

Como o usuário pode ter celular, emulador ou outro dispositivo
conectado, documentar:

``` bash
adb devices
```

e o uso de:

``` bash
adb -s SERIAL_OU_IP:PORTA <comando>
```

O `tools/install.sh` deve respeitar isso e nunca instalar
silenciosamente no dispositivo errado.

### 20.13 Troubleshooting

`docs/ADB_WIFI.md` deve incluir soluções para:

-   `adb: command not found`;
-   `failed to pair`;
-   `connection refused`;
-   `device offline`;
-   pareado mas não listado em `adb devices`;
-   porta de conexão diferente da porta de pareamento;
-   IP/porta alterados;
-   firewall;
-   isolamento de clientes Wi-Fi;
-   múltiplos dispositivos;
-   reiniciar servidor ADB:

``` bash
adb kill-server
adb start-server
```

Não sugerir Fastboot como solução para problemas de ADB Wi-Fi.

### 20.14 Encerrar a sessão

Documentar:

``` bash
adb disconnect
```

ou:

``` bash
adb disconnect IP:PORTA
```

Depois, no relógio, desativar Wireless debugging quando não for mais
necessário.

Também explicar como esquecer/revogar computadores pareados pela
intewearfaces de Wireless debugging, quando disponível.

### 20.15 Segurança

Destacar:

-   usar Wireless debugging apenas em redes confiáveis;
-   não publicar códigos de pareamento;
-   não commitar IPs/portas pessoais;
-   não deixar scripts com serial/endereço hardcoded;
-   desativar depuração quando terminar;
-   códigos de pareamento são temporários.

### 20.16 Referência oficial

O arquivo deve terminar com a documentação oficial do Android como fonte
primária:

https://developer.android.com/tools/adb

e, quando aplicável, a documentação oficial de depuração Wear OS por
Wi-Fi:

https://developer.android.com/training/wearables/get-started/debug-wifi

------------------------------------------------------------------------

## 21. Fluxo cotidiano esperado no desenvolvimento

Após o pareamento inicial:

``` text
Watch 2
  │
  ├─ ativar Wireless debugging
  │
  ▼
Fedora
  │
  ├─ adb connect IP:PORTA
  ├─ adb devices
  │
  ▼
WearFaces
  │
  └─ ./tools/install.sh aurora
          │
          ├─ valida
          ├─ testa
          ├─ compila
          └─ adb install -r
                  │
                  ▼
             Xiaomi Watch 2
```

O objetivo é que, após a configuração inicial, o ciclo de
desenvolvimento seja curto:

``` text
editar → testar → compilar → instalar → verificar no relógio
```

com o máximo possível automatizado pelos scripts do próprio repositório.

## 22. Ambiente oficial de desenvolvimento: Podman-first

O ambiente oficial e reproduzível do WearFaces deve ser baseado em
**Podman**.

O objetivo é permitir que uma máquina Fedora recém-instalada consiga
trabalhar no projeto com o mínimo possível de preparação no host.

### 22.1 Responsabilidades do host

O Fedora host deve precisar, idealmente, apenas de:

-   Git;
-   Podman;
-   ADB funcional.

O ADB pode vir do Android SDK Platform Tools já instalado pelo Android
Studio ou do pacote `android-tools` do Fedora. Não instalar uma segunda
cópia se `adb version` já funcionar.

Android Studio permanece opcional para edição, inspeção e
desenvolvimento interativo.

### 22.2 Responsabilidades do container

O container deve fornecer e fixar as versões necessárias de:

-   JDK;
-   Android SDK Command-line Tools;
-   Android SDK Platform 34;
-   Android SDK Build Tools;
-   ferramentas WFF;
-   validadores oficiais necessários;
-   demais ferramentas estritamente necessárias ao build/teste.

Usar versões explicitamente fixadas. Não depender silenciosamente de
`latest`.

### 22.3 Arquivos obrigatórios

Adicionar à raiz/estrutura:

``` text
Containerfile
.containerignore

containers/
└── README.md

docs/
└── CONTAINER.md

tools/
└── dev.sh
```

### 22.4 Fluxo

O container é responsável por:

``` text
validate → test → build → APK
```

O host é responsável por:

``` text
ADB Wi-Fi → instalação no relógio
```

Não colocar o ADB Wi-Fi dentro do container como requisito padrão.

### 22.5 Comandos de alto nível

O projeto deve buscar uma experiência semelhante a:

``` bash
./tools/dev.sh test
./tools/dev.sh build aurora
./tools/install.sh aurora
```

`dev.sh` deve:

1.  verificar Podman;
2.  criar/recriar a imagem quando necessário;
3.  montar o projeto com tratamento correto de SELinux;
4.  reutilizar caches;
5.  executar o comando solicitado dentro do container;
6.  propagar corretamente o exit code.

`install.sh aurora` deve:

1.  executar o fluxo de validação/build pelo ambiente oficial em
    container;
2.  obter o APK no diretório do projeto montado;
3.  retornar ao host;
4.  verificar ADB;
5.  identificar o destino;
6.  executar `adb install -r`;
7.  reportar sucesso/falha.

### 22.6 SELinux

Como o host principal é Fedora, os bind mounts Podman devem respeitar
SELinux.

Usar `:Z` ou `:z` conforme apropriado.

Não resolver problemas de permissões com:

-   `--privileged`;
-   desativação do SELinux;
-   montagem indiscriminada do `$HOME`.

Documentar a decisão em `docs/CONTAINER.md`.

### 22.7 Cache

Evitar downloads completos em toda execução.

A imagem deve conter os componentes Android estáveis/pinados
apropriados, e caches persistentes devem ser usados quando fizer sentido
para:

-   Gradle;
-   dependências;
-   outros caches de build seguros.

Caches nunca devem ser requisito para correção do build: um ambiente
limpo deve continuar funcionando.

### 22.8 Build nativo

O container é o ambiente oficial, mas o build nativo continua permitido.

Documentar em `docs/DEVELOPMENT.md`:

``` bash
./gradlew :faces:aurora:assembleDebug
```

para desenvolvedores que já possuam JDK/Android SDK adequados.

A CI e os scripts não devem assumir que todo colaborador usa Android
Studio.

### 22.9 CI e container

A GitHub Actions deve:

1.  executar a suíte normal;
2.  verificar que o `Containerfile` continua construindo;
3.  evitar divergência entre versões críticas usadas no container e as
    documentadas;
4.  falhar quando o ambiente reproduzível estiver quebrado.

Não é obrigatório executar Podman dentro do runner do GitHub. A CI pode
configurar diretamente JDK/Android SDK equivalentes, desde que execute
os mesmos scripts/testes e valide também o Containerfile.

### 22.10 Reprodutibilidade

`docs/CONTAINER.md` deve documentar:

-   versão/base escolhida da imagem;
-   JDK;
-   Android Command-line Tools;
-   Platform;
-   Build Tools;
-   validadores;
-   comandos para construir a imagem;
-   comandos para executar testes;
-   comandos para build;
-   caches;
-   SELinux;
-   limpeza/rebuild;
-   troubleshooting.

O objetivo é que, após reinstalar o Fedora, seja suficiente preparar
Git + Podman + ADB, clonar o repositório e deixar os scripts
reconstruírem o restante do ambiente.

------------------------------------------------------------------------

## 23. Política obrigatória de CHANGELOG

O arquivo:

``` text
CHANGELOG.md
```

na raiz é obrigatório e faz parte da fonte de verdade do projeto.

### 23.1 Regra principal

**Toda alteração relevante no projeto deve ser registrada no
`CHANGELOG.md`.**

Isso inclui, conforme aplicável:

-   novos mostradores;
-   novas opções/temas;
-   alterações visuais;
-   complications;
-   AOD;
-   correções;
-   compatibilidade;
-   mudanças de build;
-   mudanças de Gradle;
-   mudanças do Containerfile;
-   mudanças de CI;
-   mudanças de scripts;
-   mudanças de documentação que alterem procedimentos;
-   dependências;
-   alterações de requisitos;
-   remoções/depreciações.

### 23.2 Formato

Usar uma seção de desenvolvimento não lançada:

``` markdown
# Changelog

## [Unreleased]

### Added
- ...

### Changed
- ...

### Fixed
- ...

### Removed
- ...
```

Categorias sem conteúdo podem ser omitidas.

Ao criar uma release, mover as entradas pertinentes de `[Unreleased]`
para uma seção versionada e datada:

``` markdown
## [1.0.0] - 2026-XX-XX
```

e recriar/manter `[Unreleased]` no topo.

### 23.3 Disciplina de desenvolvimento

Uma tarefa não deve ser considerada concluída se introduziu alteração
relevante e o changelog não foi atualizado.

O Codex deve, antes de concluir qualquer implementação:

1.  inspecionar `CHANGELOG.md`;
2.  determinar se a tarefa produziu mudança registrável;
3.  adicionar a entrada em `[Unreleased]`;
4.  evitar duplicatas;
5.  descrever a mudança do ponto de vista do projeto/usuário, não como
    diário interno de raciocínio.

### 23.4 CI

Adicionar uma verificação automatizada razoável para reduzir o risco de
PRs relevantes esquecerem o changelog.

A verificação não deve impedir mudanças puramente administrativas quando
houver uma justificativa/documentação explícita adotada pelo projeto.

O Codex deve escolher uma implementação simples, auditável e
documentá-la em `CONTRIBUTING.md` e `docs/TESTING.md`.

### 23.5 Releases

O workflow `release.yml` deve verificar que:

-   existe uma seção correspondente à versão/tag ou que o processo de
    release está coerentemente documentado;
-   o changelog não está em estado obviamente inconsistente;
-   a release não silencie mudanças relevantes.

Não gerar changelog inteiro automaticamente a partir de commits como
substituto do arquivo mantido manualmente.

------------------------------------------------------------------------

## 24. Árvore consolidada atualizada

A estrutura-alvo passa a ser:

``` text
weawearfacess/
├── MASTER_SPEC.md
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CHANGELOG.md
├── Containerfile
├── .containerignore
├── settings.gradle.kts
├── build.gradle.kts
├── gradle.properties
├── gradlew
├── gradlew.bat
├── gradle/
│   ├── libs.versions.toml
│   └── wrapper/
│
├── containers/
│   └── README.md
│
├── faces/
│   └── aurora/
│       ├── README.md
│       ├── build.gradle.kts
│       └── src/main/
│           ├── AndroidManifest.xml
│           └── res/
│               ├── drawable/
│               ├── raw/watchface.xml
│               ├── values/
│               └── xml/watch_face_info.xml
│
├── shared-source/
│   ├── artwork/aurora/
│   ├── icons/
│   └── fonts/
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DEVELOPMENT.md
│   ├── TESTING.md
│   ├── CONTAINER.md
│   ├── ADB_WIFI.md
│   ├── DESIGN_GUIDELINES.md
│   ├── RELEASE.md
│   ├── ROADMAP.md
│   └── watchfaces/
│       └── SUNLIGHT.md
│
├── tools/
│   ├── dev.sh
│   ├── build-all.sh
│   ├── validate.sh
│   ├── test.sh
│   ├── install.sh
│   └── checksums.sh
│
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── bug.yml
    │   └── watchface-request.yml
    ├── pull_request_template.md
    └── workflows/
        ├── ci.yml
        └── release.yml
```

Esta árvore substitui representações anteriores quando houver
divergência.

------------------------------------------------------------------------

## 25. Procedimento do Codex --- complemento

Além do procedimento já definido, toda tarefa futura deve considerar
explicitamente:

1.  usar Podman como ambiente oficial quando a tarefa envolver
    build/testes;
2.  preservar o fallback de build nativo;
3.  executar os testes locais aplicáveis;
4.  validar o Containerfile quando alterado;
5.  atualizar documentação quando o procedimento mudar;
6.  atualizar `CHANGELOG.md` em `[Unreleased]` para toda mudança
    relevante;
7.  nunca considerar a tarefa finalizada apenas porque o código compila;
8.  informar exatamente quais testes foram executados e quais
    permaneceram pendentes.

## 26. Política de commits

O projeto deve adotar **Conventional Commits** para todas as mensagens
de commit.

Criar obrigatoriamente:

``` text
docs/COMMIT_CONVENTION.md
```

e referenciá-lo em `CONTRIBUTING.md`.

### 26.1 Formato

``` text
<type>(<scope>): <description>
```

Exemplos:

``` text
feat(aurora): add configurable complication slots
fix(aod): reduce ambient resource usage
build(container): pin Android build tools
test(aurora): validate required WFF resources
docs(adb): document wireless reconnection
ci: validate container build
```

### 26.2 Tipos

Usar, conforme aplicável:

-   `feat` --- nova funcionalidade;
-   `fix` --- correção;
-   `refactor` --- mudança interna sem alteração funcional intencional;
-   `perf` --- desempenho/eficiência;
-   `test` --- testes;
-   `docs` --- documentação;
-   `build` --- Gradle, Android SDK, Containerfile e infraestrutura de
    build;
-   `ci` --- GitHub Actions e automação de CI;
-   `chore` --- manutenção que não se encaixa melhor nas categorias
    anteriores;
-   `revert` --- reversão.

### 26.3 Escopos

Preferir escopos semanticamente úteis:

``` text
aurora
minimal
digital
activity
classic
aod
container
gradle
adb
release
wff
```

Não inventar escopo apenas para preencher o campo. O escopo pode ser
omitido quando a alteração for realmente transversal.

### 26.4 Descrição

-   usar frase curta e objetiva;
-   descrever a alteração, não o processo mental;
-   evitar mensagens genéricas como `update files`, `changes`,
    `fix stuff`;
-   manter consistência de idioma definida pelo projeto;
-   não incluir ponto final desnecessário no título.

### 26.5 Corpo do commit

Para alterações não triviais, adicionar corpo explicando contexto e
impacto.

Quando útil, incluir uma seção de testes:

``` text
Tests:
- ./tools/test.sh
- WFF validation
- Aurora debug build
```

Não declarar teste como executado se ele não foi realmente executado.

### 26.6 Breaking changes

Mudanças incompatíveis devem usar a convenção oficial, por exemplo:

``` text
feat!: change minimum supported Wear OS version
```

ou rodapé:

``` text
BREAKING CHANGE: ...
```

Qualquer breaking change deve também ser registrado claramente no
`CHANGELOG.md`.

------------------------------------------------------------------------

## 27. Responsabilidade do Codex sobre commits

Ao concluir uma unidade lógica de trabalho, o Codex deve:

1.  inspecionar `git status`;
2.  analisar `git diff`;
3.  separar mudanças independentes em commits lógicos quando apropriado;
4.  garantir que testes relacionados foram executados;
5.  atualizar `CHANGELOG.md` quando a mudança for registrável;
6.  gerar uma mensagem Conventional Commit semanticamente adequada;
7.  incluir corpo quando a alteração precisar de contexto;
8.  registrar testes executados quando isso trouxer valor;
9.  nunca misturar alterações independentes apenas por conveniência;
10. nunca usar mensagens vagas.

Se o ambiente/sessão estiver autorizado a criar commits, o Codex pode
efetivamente criá-los. Caso não esteja, deve fornecer as mensagens de
commit propostas no relatório final.

O Codex nunca deve alterar, reescrever, fazer squash, amend ou
force-push de histórico publicado sem instrução explícita.

------------------------------------------------------------------------

## 28. Validação automática de commits

A CI deve validar mensagens de commit de PRs conforme Conventional
Commits.

A implementação deve ser simples, auditável e compatível com o fluxo do
GitHub Actions.

A validação deve rejeitar exemplos como:

``` text
update
fix stuff
changes
new files
```

e aceitar exemplos como:

``` text
feat(aurora): add ambient color variants
fix(wff): correct complication slot bounds
build(container): update pinned command-line tools
docs(adb): clarify pairing and connection ports
```

Documentar em:

``` text
docs/COMMIT_CONVENTION.md
docs/TESTING.md
CONTRIBUTING.md
```

como executar localmente a mesma validação quando possível.

Evitar adicionar uma cadeia pesada de dependências apenas para validar
uma expressão relativamente simples se uma solução menor e confiável
atender ao projeto.

------------------------------------------------------------------------

## 29. Relação entre commit e changelog

Commit e changelog têm finalidades diferentes:

``` text
Commit
└── descreve uma unidade lógica de alteração no histórico Git

CHANGELOG.md
└── descreve mudanças relevantes do projeto/usuário ao longo das versões
```

Nem todo commit administrativo precisa necessariamente gerar uma entrada
individual no changelog, mas toda mudança relevante deve estar
representada nele.

Não gerar automaticamente o `CHANGELOG.md` inteiro a partir das
mensagens de commit. O changelog permanece curado e mantido
conscientemente.

------------------------------------------------------------------------

## 30. Fluxo completo de uma alteração

O fluxo esperado passa a ser:

``` text
implementar
    ↓
atualizar/criar testes
    ↓
executar validações
    ↓
executar testes
    ↓
build
    ↓
atualizar CHANGELOG.md
    ↓
git diff / revisão
    ↓
gerar Conventional Commit
    ↓
commit
    ↓
push
    ↓
GitHub Actions
    ├── valida commit
    ├── valida projeto
    ├── executa testes
    ├── valida Containerfile
    └── build
```

Uma tarefa não deve ser considerada concluída apenas porque o commit foi
criado. O estado final deve respeitar testes, changelog, documentação e
CI.

## 31. Decisões definitivas de identidade, licença e versionamento

Estas decisões substituem quaisquer nomes provisórios anteriores.

### 31.1 Nome do projeto

``` text
WearFaces
```

Repositório sugerido:

``` text
wearfaces
```

### 31.2 Namespace

``` text
com.rtosta.wearfaces
```

Cada mostrador possui package ID próprio:

``` text
com.rtosta.wearfaces.<slug>
```

Primeiro mostrador:

``` text
Aurora
com.rtosta.wearfaces.aurora
```

### 31.3 Licença

Código-fonte sob **GNU General Public License v3.0 (GPL-3.0)**. Assets
próprios e de terceiros devem ter licenciamento/origem documentados
separadamente quando aplicável.

### 31.4 Versionamento

Semantic Versioning coordenado para o monorepo, iniciando em:

``` text
0.1.0
```

Tags:

``` text
v0.1.0
v0.2.0
v1.0.0
```

### 31.5 Compatibilidade

``` text
Wear OS 4   / API 33 → não suportado
Wear OS 5   / API 34 → suportado; baseline oficial
Wear OS 5.1 / API 35 → suportado enquanto compatível com WFF 2
Wear OS 6   / API 36 → suportado enquanto compatível com WFF 2
```

Nenhum recurso novo pode elevar silenciosamente o baseline global.
