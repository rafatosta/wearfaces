# ADB por Wi-Fi — Xiaomi Watch 2 + Fedora

## 1. Verificar ADB

``` bash
adb version
```

Se já funcionar pelo Android SDK/Android Studio, não instale outra cópia. Se o
comando não estiver no PATH, localize `platform-tools/adb` no SDK já instalado e
adicione esse diretório ao PATH. Como alternativa, instale `android-tools` pelo
Fedora. Uma segunda instalação não é necessária quando o ADB atual funciona.

## 2. Rede

Relógio e computador devem estar na mesma rede Wi-Fi, sem isolamento entre
clientes. Redes guest, corporativas ou com AP/client isolation podem bloquear a
conexão mesmo com internet disponível.

## 3. Ativar opções do desenvolvedor

No relógio, abra Configurações → Sistema/Sobre, localize Número da versão/Build
number e toque repetidamente (normalmente sete vezes) até ativar o modo
desenvolvedor. Volte às Configurações e abra Opções do desenvolvedor. Nomes de
menus podem mudar ligeiramente após atualizações.

## 4. Ativar depuração sem fio

Ative Depuração ADB, quando exibida, e Depuração sem fio/Wireless debugging;
aceite o aviso. Faça isso apenas em rede confiável e desative ao terminar.

## 5. Parear

Em Wireless debugging, escolha Parear novo dispositivo. Anote IP, porta de
pareamento e código temporário.

No Fedora:

``` bash
adb pair IP:PORTA_DE_PAREAMENTO
```

Exemplo ilustrativo: `adb pair 192.168.1.50:37123`. Digite o código exibido e
nunca publique ou versione esse código.

A porta de pareamento não deve ser presumida como a porta usada por
`adb connect`.

## 6. Conectar

Volte à tela principal de Wireless debugging e consulte IP e **porta de
conexão**, que pode ser diferente:

``` bash
adb connect IP:PORTA_DE_CONEXAO
adb devices
```

Exemplo ilustrativo: `adb connect 192.168.1.50:41987`. O resultado deve listar
`192.168.1.50:41987 device`.

## 7. Verificar dispositivo

``` bash
adb shell getprop ro.product.manufacturer
adb shell getprop ro.product.model
adb shell getprop ro.build.version.sdk
```

Para o alvo Wear OS 5 do projeto, a API esperada é 34. Confirme também modelo e
fabricante antes de instalar.

## 8. Conceitos

``` text
adb pair    → estabelece confiança
adb connect → abre a sessão ADB
adb devices → confirma a sessão ativa
```

## 9. Reconexão

Parear não conecta automaticamente. IP e especialmente as portas podem mudar ao
reiniciar relógio/Wi-Fi, alternar Wireless debugging ou mudar de rede. Se a
confiança continuar salva, normalmente basta reativar a depuração e rodar
`adb connect IP:PORTA_ATUAL`, seguido de `adb devices`; não repita `adb pair`.

Opcionalmente:

``` bash
adb mdns services
```

O mDNS pode descobrir serviços pareados, mas não é requisito:

```bash
adb mdns services
```

Use a conexão manual como fallback confiável.

## 10. Múltiplos dispositivos

``` bash
adb -s SERIAL_OU_IP:PORTA <comando>
```

O script de instalação nunca deve escolher silenciosamente o dispositivo
errado. Consulte `adb devices` e use `./tools/install.sh aurora --device SERIAL`.

## 11. Troubleshooting

### `adb: command not found`

Confira o SDK Platform Tools já instalado ou o pacote `android-tools`.

### `failed to pair`

Gere novo código, confirme IP/porta de **pareamento**, proximidade e mesma rede.

### `connection refused` ou pareado mas ausente em `adb devices`

Use a porta de **conexão** atual com `adb connect`; ela não é a de pareamento.
Revise firewall e isolamento da rede.

### `device offline`

Desconecte/reconecte o endereço atual. Se necessário, reinicie somente o
servidor ADB:

```bash
adb kill-server
adb start-server
```

Depois rode `adb connect` novamente. Se há múltiplos dispositivos, especifique o
serial. Não use Fastboot: ele não corrige ADB por Wi-Fi.

## 12. Encerrar

```bash
adb disconnect
adb disconnect IP:PORTA
```

Desative Wireless debugging quando terminar. Na interface de Wireless debugging
do relógio, esqueça/revogue computadores pareados quando necessário (o nome da
opção varia por versão).

Não versione IPs, portas ou seriais pessoais. Códigos são temporários, mas devem
continuar privados.

## Referências oficiais

- [Android Debug Bridge](https://developer.android.com/tools/adb)
- [Depurar Wear OS por Wi-Fi](https://developer.android.com/training/wearables/get-started/debug-wifi)
