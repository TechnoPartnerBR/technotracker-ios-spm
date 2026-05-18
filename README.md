# TechnoTracker SDK para iOS

SDK de rastreamento e telemetria da TechnoPartner para aplicativos iOS.

## Requisitos

- iOS 14.0+
- Xcode 14.0+
- Swift 5.7+

## Instalacao

### Passo 1: Configurar autenticacao

O download do SDK requer autenticacao. Crie o arquivo `~/.netrc` no seu diretorio home com as credenciais fornecidas pela TechnoPartner:

```
machine spm-sdk.technopartner.com.br
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

### Passo 3: Inicializar e iniciar o SDK

Importe o modulo e inicialize o SDK no `AppDelegate` utilizando `FinderManager`:

> **Importante:** `setup()` é um método síncrono. Chame-o diretamente em `application(_:didFinishLaunchingWithOptions:)` — **não** envolva em `Task { await ... }`.

```swift
import IoTracker

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene { WindowGroup { ContentView() } }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let config = IoTrackerConfiguration(apiKey: "token-fornecido-pela-technopartner")
        FinderManager.shared.setup(configuration: config, launchOptions: launchOptions)

        // Na primeira instalação: use startExplicit() para ativar o SDK.
        // Nos lançamentos seguintes: start() retoma a execução automaticamente se já foi ativado.
        FinderManager.shared.start()

        return true
    }
}
```

#### Parametros de configuracao

| Parametro | Descricao | Padrao |
|-----------|-----------|--------|
| `apiKey` | Token criptografado (obrigatorio) | — |

### Ciclo de vida do SDK

O ciclo de vida é dividido em duas fases independentes: **configuração** (`setup`) e **execução** (`start`/`stop`).

| Método | Descrição |
|--------|-----------|
| `setup(configuration:launchOptions:)` | Configura o SDK e inicializa os objetos internos. **Não** inicia nenhuma execução reativa. Deve ser chamado na main thread em `application(_:didFinishLaunchingWithOptions:)`. |
| `startExplicit()` | Inicia todas as features do SDK e **persiste** o estado iniciado. Chame uma vez para ativar o SDK pela primeira vez. Nos lançamentos seguintes, use `start()`. |
| `start()` | Inicia as features apenas se `startExplicit()` já tiver sido chamado em uma sessão anterior. Não faz nada caso contrário. |
| `stop()` | Para todas as features e **persiste** o estado parado. Após `stop()`, `start()` será um no-op até que `startExplicit()` seja chamado novamente. |
| `isRunning` | `true` enquanto as features estão em execução na **sessão atual**. Resetado para `false` a cada novo lançamento até que `start()` ou `startExplicit()` seja chamado. |

#### Padrões de uso

**Primeira instalação:**

```swift
FinderManager.shared.setup(configuration: config, launchOptions: launchOptions)
FinderManager.shared.startExplicit()   // persiste a intenção + inicia as features
```

**Lançamentos seguintes:**

```swift
FinderManager.shared.setup(configuration: config, launchOptions: launchOptions)
FinderManager.shared.start()   // no-op se nunca foi ativado explicitamente
```

**Parar o SDK (ex: logout do usuário):**

```swift
FinderManager.shared.stop()   // para as features + limpa a intenção persistida
```

**Verificar estado em tempo de execução:**

```swift
if FinderManager.shared.isRunning {
    // features em execução
}
```

### Passo 4: Registrar ID da antena

Antes de utilizar o SDK, é necessário registrar um ID de antena. O fluxo recomendado é verificar se um ID já foi registrado anteriormente e, caso não tenha sido, realizar o registro.

**1. Verificar se o ID já está registrado**

```swift
let registered = try await FinderManager.shared.isAntennaIdRegistered()
if !registered {
    // Prosseguir com o registro
}
```

**2. Gerar um seed e registrar o ID**

Caso o ID ainda não esteja registrado, gere um seed e chame `registerId`. A forma preferencial é via `antennaIdSeed(safeToken:)`:

```swift
let seed = antennaIdSeed(safeToken: "seu-safe-token")
try await FinderManager.shared.registerId(seed: seed)
```

Outros métodos disponíveis para geração de seed:

```swift
// Via login
let seed = antennaIdSeed(login: "usuario@email.com")

// Via UUID
let seed = antennaIdSeed(uuid: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

// Aleatório
let seed = randomAntennaIdSeed()
```

**3. Obter o ID registrado**

```swift
let antennaId: UInt64 = try await FinderManager.shared.getAntennaId()
print("Antenna ID: \(antennaId)")
```

### Passo 5: Verificar e solicitar permissões

O SDK oferece APIs para verificar e solicitar as permissões de Localização e Bluetooth. Todos os métodos retornam um valor `PermissionStatus`:

| Valor | Significado |
|-------|-------------|
| `.granted` | Permissão concedida |
| `.pendingAction` | Negada ou parcial — usuário deve acessar as Configurações |
| `.restricted` | Restrita por MDM ou controle parental; não pode ser alterada pelo usuário |
| `.denied` | Ainda não determinada |

**Verificar status atual (sem exibir diálogo do sistema)**

```swift
let locationStatus  = try await FinderManager.shared.checkLocationPermission()
let bluetoothStatus = try await FinderManager.shared.checkBluetoothPermission()
```

**Solicitar permissões**

```swift
let locationStatus  = try await FinderManager.shared.requestLocationPermission()
let bluetoothStatus = try await FinderManager.shared.requestBluetoothPermission()
```

> `requestLocationPermission()` trata o fluxo de upgrade `authorizedWhenInUse` → `authorizedAlways` abrindo a página de Configurações do app e resolvendo após o retorno do usuário. Ambos os métodos suportam cancelamento via `Task`.

> O SDK nunca solicita permissões de forma autônoma. Cabe ao app host chamar esses métodos no momento adequado.

## Suporte

Para duvidas ou suporte tecnico, entre em contato com a equipe da TechnoPartner.
