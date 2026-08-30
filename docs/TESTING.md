# Testes

`./tools/dev.sh test` é a suíte canônica. Ela verifica árvore/scripts, XML,
manifest resource-only, WFF 2, SDK 35/35/34, package ID, data, paletas,
complications, AOD, schema WFF oficial, Conventional Commits, doctor, geração e
compilação do template, changelog, Gradle checks, APK debug, AAB release e
limites oficiais de memória (10 MB ambiente, 100 MB interativo).

`tools/validate-face-specs.sh` também verifica o template obrigatório e exige
que cada módulo vincule uma especificação completa sob `docs/watchfaces/`, com
slug e package ID coerentes. Isso impede que uma foto/mockup seja transformada
diretamente em código sem decisões auditáveis.

Comandos úteis:

```bash
./tools/dev.sh validate
./tools/validate-face-specs.sh
./tools/dev.sh test
./tools/validate-commit.sh --self-test
./tools/validate-commit.sh 'fix(wff): correct slot bounds'
```

Em PR, `check-changelog.sh` compara com a base. Mudança relevante exige o
arquivo; uma exceção administrativa precisa da linha documentada descrita em
`CONTRIBUTING.md`. A CI valida todas as mensagens do range do PR e reutiliza os
scripts, depois constrói o container e publica APKs debug.

O emulador não roda na CI porque o runner atual não oferece KVM como contrato.
Em host com KVM, teste `emulator --headless`, boot, `adb devices`, instalação e
package instalado. Janela Wayland/X11 e renderização visual continuam testes de
hardware/desktop, não inferências do build.

## Hardware pendente até execução real

No Xiaomi Watch 2, testar: instalação e picker; 00:00, 03:15, 06:30, 09:45 e
12:00; virada da data; slots vazios/configurados; todas as paletas; entrada e
saída do AOD; legibilidade/clipping; reboot; troca e retorno; atualização e
reinstalação. Registre modelo, build do sistema e resultado de cada caso.

O build headless não renderiza com fidelidade o runtime WFF do dispositivo.
Golden tests só serão adotados quando houver ferramenta oficial determinística;
preview vetorial e validação de schema não contam como aprovação visual.
