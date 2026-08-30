# {{WATCH_FACE_NAME}} — especificação

> Rascunho gerado automaticamente. Complete as decisões materiais e marque a
> especificação como aprovada antes de desenvolver o design definitivo.

## 1. Identidade e proveniência

- Nome: `{{WATCH_FACE_NAME}}`
- Slug: `{{MODULE_NAME}}`
- Package ID: `{{PACKAGE_NAME}}`
- Estado: `rascunho`
- Tipo de referência: `nenhuma`
- Origem/autoria da referência: `não aplicável`
- Autorização/licença: `design original a definir`

## 2. Leitura da referência

### Observado

- Nenhuma referência foi fornecida.

### Inferido

- Nenhum detalhe foi inferido.

### Decidido para a criação original

- O template inicial é digital, simples e substituível.

### Incertezas materiais

- Design definitivo, complications, paletas e assets.

## 3. Intenção e não objetivos

Definir a intenção antes de implementar. Não elevar WFF/minSdk, adicionar rede,
telemetria ou copiar recursos proprietários.

## 4. Especificação visual

Canvas WFF: `450 × 450`; centro: `(225, 225)`. Substitua o layout inicial por
uma composição documentada, incluindo coordenadas, tipografia e área segura.

## 5. Mapeamento WFF 2

- Relógio inicial: digital com `DigitalClock` e `TimeText`.
- Data inicial: dia da semana e dia do mês.
- Versão: WFF 2; `minSdk 34`; `compileSdk/targetSdk 35`.

## 6. Complications

Nenhuma no template. Documente slots, tipos e estado vazio antes de adicioná-los.

## 7. Configurações e paletas

O template oferece branco, azul e âmbar apenas como exemplos neutros. Substitua
por paletas aprovadas na especificação final.

## 8. AOD

O template reduz o alpha da hora e data. Documente pixels acesos, legibilidade
e elementos ocultos para o design final.

## 9. Assets e licenças

O template não contém assets externos. Registre autoria, licença e processo de
geração de todo asset futuro.

## 10. Acessibilidade e localização

Complete contraste, tamanhos, nomes localizáveis e idiomas antes do aceite.

## 11. Prompt normalizado para o Codex

```text
Implemente {{WATCH_FACE_NAME}} em faces/{{MODULE_NAME}}, package
{{PACKAGE_NAME}}, preservando WFF 2, minSdk 34, targetSdk 35, formato
resource-only, funcionamento offline e assets originais/licenciados.
Use esta especificação preenchida como fonte de verdade.
```

## 12. Critérios de aceite

- [ ] especificação aprovada antes do design definitivo;
- [ ] WFF 2, `minSdk 34`, `targetSdk 35` e `android:hasCode="false"`;
- [ ] lint, schema WFF, memória, APK e AAB aprovados;
- [ ] assets e comportamento AOD documentados;
- [ ] testes em hardware registrados separadamente.

## 13. Testes físicos pendentes

Instalação, picker, horários de referência, virada da data, configurações, AOD,
clipping, reboot, troca/retorno e atualização/reinstalação.
