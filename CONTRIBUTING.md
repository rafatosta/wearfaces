# Contribuindo

Ao contribuir, você concorda em publicar sua contribuição de código sob
GPL-3.0-only e declara possuir direitos sobre os assets enviados.

## Fluxo

1. Crie uma branch curta e mantenha a alteração focada.
2. Implemente e atualize testes/documentação.
3. Registre mudanças relevantes em `CHANGELOG.md`, na seção `[Unreleased]`.
4. Execute `./tools/dev.sh test`.
5. Use [Conventional Commits](docs/COMMIT_CONVENTION.md).
6. Abra um PR descrevendo o resultado e testes realmente executados.

Uma mudança puramente administrativa pode omitir o changelog se o PR trouxer
uma linha `Changelog: not required - MOTIVO`. A CI verifica esse contrato.

## Novo mostrador

Antes de criar o módulo, copie
[`docs/watchfaces/TEMPLATE.md`](docs/watchfaces/TEMPLATE.md), preencha
`docs/watchfaces/<NOME>.md` e siga
[`docs/REFERENCE_TO_SPEC.md`](docs/REFERENCE_TO_SPEC.md). Foto, screenshot,
desenho ou mockup não pode ser implementado diretamente sem essa tradução. O
README do módulo deve conter:

```markdown
- Especificação: [<NOME>](../../docs/watchfaces/<NOME>.md)
```

Depois, crie `faces/<slug>/` e `shared-source/artwork/<slug>/`; inclua
`:faces:<slug>` em
`settings.gradle.kts`, adicione-o à tabela do README e mantenha package ID
`com.rtosta.wearfaces.<slug>`. O módulo deve continuar resource-only,
`android:hasCode="false"`, WFF 2 e `minSdk = 34`, salvo decisão anterior no
`MASTER_SPEC.md`.

Não copie configurações, imagens, fontes ou geometria proprietária. Documente
origem/licença de cada asset e preserve o funcionamento offline, sem telemetria.
Execute `./tools/validate-face-specs.sh` antes de começar o build.

## Validação local

```bash
./tools/dev.sh validate
./tools/dev.sh test
./tools/validate-commit.sh 'feat(aurora): add dial option'
```

Testes de relógio devem informar modelo, versão e casos executados. Não marque
testes físicos como aprovados sem hardware real.
