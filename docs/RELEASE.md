# Releases

## Versionamento

SemVer coordenado para todo o monorepo:

``` text
0.1.0 → v0.1.0
```

Antes de criar `vX.Y.Z`, mova as entradas pertinentes de `[Unreleased]` para
`## [X.Y.Z] - AAAA-MM-DD`, atualize `versionName`/`versionCode` dos módulos e
rode `./tools/check-release.sh vX.Y.Z` e a suíte completa.

## Processo automatizado

1. checkout e ambiente JDK/Android;
2. coerência tag, módulos e changelog;
3. suíte completa;
4. build release assinado;
5. nomes previsíveis e `SHA256SUMS`;
6. GitHub Release com APKs.

## Assinatura

Keystore e credenciais nunca entram no Git. Gere uma chave de upload com
`keytool`, mantenha backup offline testado e restrinja acesso. A perda impede
atualizações compatíveis fora dos mecanismos de rotação da loja.

Secrets esperados:

- `ANDROID_KEYSTORE_BASE64`: conteúdo do keystore em Base64, sem quebras;
- `ANDROID_STORE_PASSWORD`;
- `ANDROID_KEY_ALIAS`;
- `ANDROID_KEY_PASSWORD`.

O workflow decodifica em diretório temporário e expõe apenas variáveis
`WEARFACES_*` durante o build. Forks/PRs não recebem os secrets. Releases locais
sem essas variáveis produzem APK release não assinado e não devem ser publicados.

## Assets de release

Exemplo:

``` text
aurora-0.1.0.apk
essential-0.1.0.apk
flow-0.1.0.apk
SHA256SUMS
```

Verifique `sha256sum -c SHA256SUMS`, instale o APK em hardware, confirme
assinatura/package ID e só então publique. Artifacts de CI debug nunca são
assets de release.
