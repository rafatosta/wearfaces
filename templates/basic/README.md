# {{WATCH_FACE_NAME}}

Mostrador WFF 2 gerado a partir do template `basic`.

- Especificação: [{{WATCH_FACE_NAME}}](../../docs/watchfaces/{{SPEC_FILE}}.md)

Edite `src/main/res/raw/watchface.xml` para implementar o design. Antes de
substituir o mostrador inicial, complete e aprove a especificação vinculada.

```bash
./scripts/wearfaces validate {{MODULE_NAME}}
./scripts/wearfaces build {{MODULE_NAME}}
./scripts/wearfaces preview {{MODULE_NAME}}
./scripts/wearfaces bundle {{MODULE_NAME}}
```
