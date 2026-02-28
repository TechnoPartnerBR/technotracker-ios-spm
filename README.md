# TechnoTracker SDK para iOS

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
3. Em **Dependency Rule** selecione **"Branch"** e insira `main`
4. Clique em **Add Package**
5. Selecione o produto **IoTracker** e adicione ao seu target

> **Nota**: Atualmente não é possível selecionar uma versão específica para a dependência. 

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

#### Parametros de configuracao

| Parametro | Descricao | Padrao |
|-----------|-----------|--------|
| `apiKey` | Token criptografado (obrigatorio) | — |

### Passo 4: Configurar SDK

#### Registrar ID

Antes de utilizar o SDK, é necessário registrar um ID de antena. O fluxo recomendado é verificar se um ID já foi registrado anteriormente e, caso não tenha sido, realizar o registro.

**1. Verificar se o ID já está registrado**

```swift
IoTracker.shared.isAntennaIdRegistered(onSuccess: { isRegistered in
    if !isRegistered {
        // Prosseguir com o registro
    }
}, onError: { error in
    // Tratar erro
})
```

**2. Gerar um seed e registrar o ID**

Caso o ID ainda não esteja registrado, gere um seed e chame `registerId`. A forma preferencial de gerar o seed é via `antennaIdSeed(safeToken:)`:

```swift
let seed = IoTracker.shared.antennaIdSeed(safeToken: "seu-safe-token")

IoTracker.shared.registerId(seed: seed, onSuccess: {
    // ID registrado com sucesso
}, onError: { error in
    // Tratar erro
})
```

Outros métodos disponíveis para geração de seed:

```swift
// Via login
let seed = IoTracker.shared.antennaIdSeed(login: "usuario@email.com")

// Via UUID
let seed = IoTracker.shared.antennaIdSeed(uuid: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

// Aleatório
let seed = IoTracker.shared.randomAntennaIdSeed()
```

**3. Obter o ID registrado**

Após o registro, utilize `getAntennaId` para obter o ID. Enquanto o ID não for resolvido, o valor retornado será `0`.

```swift
IoTracker.shared.getAntennaId(onSuccess: { id in
    if id != 0 {
        print("Antenna ID: \(id)")
    }
}, onError: { error in
    // Tratar erro
})
```

## Suporte

Para duvidas ou suporte tecnico, entre em contato com a equipe da TechnoPartner.
