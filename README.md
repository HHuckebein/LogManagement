# LogManagement
Swift helper for CocoaLumberjack. Maintain global/local loglevels.

Provides

* a wrapper implementation to hide CocoaLumberjack usage
* maintains a global log level settings dictionary
* provides methods to set a different log level certain types

### Set global log leve

```Swift
    InitializeLogging(withLogLevel: .warning)
```

### Enable different level

```Swift
LogManager.registerLogLevel(forClassNames: [String(describing: SubClassA.self): .debug,
                                            String(describing: SubClassB.self): .info,
                                            String(describing: SomeStruct.self): .verbose])
```

### Usage examples

```Swift

// MARK: - Class Type

class BaseClass: LogLevel {}

class SubClassA: BaseClass {
    func sampleFunction() {
        LogDebug(logText: "\(self)", level: logLevel)
    }
}

class SubClassB: BaseClass {
    func sampleFunction() {
        LogInfo(logText: "\(self)", level: logLevel)
    }
}

class SubClassC: BaseClass {
    func sampleFunction() {
        LogInfo(logText: "\(self)", level: logLevel)
    }
}

// MARK: - Struct's

struct SomeStruct: LogLevel {
    func sampleFunction() {
        LogVerbose(logText: "\(self)", level: logLevel)
    }
}

// MARK: - Enum's

enum SomeEnum: LogLevel {
    case one
    case two

    func status() {
        LogWarn(logText: "\(self)", level: logLevel)
    }
}
```

### License
- LogManager is available under the MIT license. See the [LICENSE file](https://github.com/github/HHuckebein/LogManager/blob/master/LICENSE.txt).



