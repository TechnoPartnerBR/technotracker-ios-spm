# IoTracker SDK para iOS

SDK de rastreamento e telemetria da TechnoPartner para aplicativos iOS.

## Requisitos

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Instalacao

### Passo 1: Configurar autenticacao

O download do SDK requer autenticacao. Crie o arquivo `~/.netrc` no seu diretorio home com as credenciais fornecidas pela TechnoPartner:

```
machine ios-sdk.technopartner.com.br
  login <usuario-fornecido>
  password <senha-fornecida>
```

> **Nota:** As credenciais sao fornecidas pela TechnoPartner durante o processo de integracao.

### Passo 2: Adicionar dependencia no Xcode

1. No Xcode, acesse **File > Add Package Dependencies...**
2. Insira a URL do repositorio:
   ```
   https://github.com/TechnoPartnerBR/technotracker-ios-spm.git
   ```
3. Selecione a versao desejada (recomendado: **Up to Next Major Version**)
4. Clique em **Add Package**
5. Selecione o produto **IoTracker** e adicione ao seu target

### Passo 3: Inicializar o SDK

No codigo da sua aplicacao, importe o modulo e inicialize com a chave API fornecida:

```swift
import IoTracker

// Na inicializacao do app (AppDelegate ou @main App)
let config = IoTrackerConfiguration(
    apiKey: "token-fornecido-pela-technopartner"
)
IoTracker.shared.setup(configuration: config)
```

## Parametros de configuracao

| Parametro | Descricao | Padrao |
|-----------|-----------|--------|
| `apiKey` | Token criptografado (obrigatorio) | — |
| `environment` | `.production` ou `.development` | `.production` |

## Suporte

Para duvidas ou suporte tecnico, entre em contato com a equipe da TechnoPartner.
