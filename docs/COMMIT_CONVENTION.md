# Convenção de commits

O WearFaces usa **Conventional Commits**.

## Formato

``` text
<type>(<scope>): <description>
```

## Tipos

-   `feat`: nova funcionalidade
-   `fix`: correção
-   `refactor`: alteração interna sem mudança funcional intencional
-   `perf`: desempenho/eficiência
-   `test`: testes
-   `docs`: documentação
-   `build`: Gradle, Android SDK, Containerfile e infraestrutura de
    build
-   `ci`: GitHub Actions/CI
-   `chore`: manutenção
-   `revert`: reversão

## Escopos sugeridos

`aurora`, `flow`, `stride`, `aod`, `wff`, `container`, `gradle`, `adb`,
`release`.

## Exemplos

``` text
feat(aurora): add configurable complication slots
fix(aod): reduce ambient resource usage
build(container): pin Android build tools
test(aurora): validate required WFF resources
docs(adb): clarify wireless reconnection
ci: validate container build
```

## Commits não triviais

O corpo pode registrar contexto e testes realmente executados:

``` text
feat(aurora): add configurable complication slots

Add configurable left and right complication slots and update
the WFF resources required by the new layout.

Tests:
- ./tools/test.sh
- WFF validation
- Aurora debug build
```

## Codex

Ao concluir uma unidade lógica, o Codex deve revisar `git status` e
`git diff`, executar os testes aplicáveis, atualizar `CHANGELOG.md`
quando necessário e produzir uma mensagem Conventional Commit adequada.
Toda resposta final após modificar arquivos do repositório deve incluir pelo
menos uma mensagem de commit sugerida, mesmo para mudanças pequenas. Alterações
independentes devem receber mensagens separadas; mudanças não triviais devem
incluir também um corpo opcional com contexto e os testes realmente executados.
Não deve reescrever histórico publicado sem instrução explícita.

## Validação

Para um título específico:

```bash
./tools/validate-commit.sh 'feat(aurora): add ambient color variants'
```

`./tools/validate-commit.sh --self-test` verifica exemplos aceitos/rejeitados.
A CI define `COMMIT_RANGE` para validar todas as mensagens introduzidas pelo PR.
Breaking changes usam `type!:` ou `type(scope)!:` e precisam também do changelog.
