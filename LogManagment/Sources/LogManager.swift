//
//  LogManager.swift
//  LogManagment
//
//  Created by Bernd Rabe on 21.08.16.
//  Copyright © 2016 RABE_IT Services. All rights reserved.
//

import Foundation
import CocoaLumberjack

public func InitializeLogging(withLogLevel logLevel: DDLogLevel = .warning) {
    DDLog.add(DDTTYLogger.sharedInstance())
    defaultDebugLevel = logLevel
}

public func SetLoggingLevel(logLevel: DDLogLevel) {
    defaultDebugLevel = logLevel
}

public func AddFileLogging(forLogLevel logLevel: DDLogLevel) {
    if let logFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        let logFileManager = DDLogFileManagerDefault(logsDirectory: logFilePath)
        if let fileLogger = DDFileLogger(logFileManager: logFileManager) {
            fileLogger.rollingFrequency = 60 * 60 * 24
            DDLog.add(fileLogger, with: logLevel)
        } else {
            print("File logging couldn't be enabled")
        }
    }
}

// Turn off logging if not in DEBUG mode (security measure)
#if DEBUG
    public func LogDebug(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
        _DDLogMessage(message: logText, level: level, flag: .debug, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: DDLog.sharedInstance())
    }
    
    public func LogInfo(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
        _DDLogMessage(message: logText, level: level, flag: .info, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: DDLog.sharedInstance())
    }
    
    public func LogWarn(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
        _DDLogMessage(message: logText, level: level, flag: .warning, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: DDLog.sharedInstance())
    }
    
    public func LogVerbose(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
        _DDLogMessage(message: logText, level: level, flag: .verbose, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: DDLog.sharedInstance())
    }
    
    public func LogError(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
        _DDLogMessage(message: logText, level: level, flag: .error, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: DDLog.sharedInstance())
    }
#else
    public func LogDebug(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    }
    
    public func LogInfo(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    }
    
    public func LogWarn(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    }
    
    public func LogVerbose(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    }
    
    public func LogError(logText: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    }
#endif

// MARK: - LogManager

public struct LogManagerConstants {
    static let DefaultsName = "LogLevels"
}

public protocol LogLevel {
    var logLevel: DDLogLevel { get }
}

/** Provides an API to use dynamic loglevel changes.
 All loglevels are stored in a volatile domain using UserDefaults.
 A loglevel for a class gets automatically registered with the defaultDebugLevel if it
 uses one of the Log??? methods with `level: self.logLevel`parameter.
 Alternativ one can register a class with a specific loglevel by using the
 `registerLogLevel(forClassNames:)` method.
 For security reasons all Log??? methods do nothing in non DEBUG mode.
 To turn off logging for all classes except your own use `disableLoggingExcept(forClass:)`.
 Sample implementation for class XYZ
    ```
    extension XYZ: LogLevel {
        public var logLevel: DDLogLevel {
            return LogManager.logLevel(forClassName: String(self.dynamicType))
        }
    }
    ```
 */
public struct LogManager {
/** Sets the logLevel for a given class with name.
 
 - Parameter className: The name of the class for which the logLevel should be set.
 - Parameter level: The logLevel given as DDLogLevel.
*/
    public static func setLogLevel(forClassName className: String, level: DDLogLevel) {
        if var logLevelDefaults = allLogLevelDefaults, className.characters.count != 0 {
            logLevelDefaults[className] = level.rawValue
            UserDefaults().setVolatileDomain(logLevelDefaults, forName: LogManagerConstants.DefaultsName)
        }
    }
    
/** Prints all known logLevels. */
    public static func showAllLogLevels () {
        if let logLevelDefaults = allLogLevelDefaults {
            for logInfo in logLevelDefaults {
                if let logLevel = DDLogLevel(rawValue: logInfo.1) {
                    print("\(logInfo.0) = \(logLevel)")
                }
            }
        }
    }
    
/** Returns the logLevel for the given class name. If the class has not yet been registered
 it is set to the `defaultDebugLevel`.
          - Parameter className: The name of the class for which the logLevel should be set.
 */
    public static func logLevel(forClassName className: String) -> DDLogLevel {
        if let logLevelDefaults = allLogLevelDefaults, let rawValue = logLevelDefaults[className], let logLevel = DDLogLevel(rawValue: rawValue) {
            return logLevel
        } else {
            setLogLevel(forClassName: className, level: defaultDebugLevel)
            return defaultDebugLevel
        }
    }
    
/** Sets the logLevel for all classes to .off, except for the given class name.
     
 - Parameter forClassName: Defines the exception for setting the logLevel to .off.
*/
    public static func disableLoggingExcept(forClassName className: String) {
        if var logLevelDefaults = allLogLevelDefaults {
            for logInfo in logLevelDefaults where logInfo.0 != className {
                logLevelDefaults[logInfo.0] = DDLogLevel.off.rawValue
            }
            UserDefaults().setVolatileDomain(logLevelDefaults, forName: LogManagerConstants.DefaultsName)
        }
    }
    
/** Register logLevels for class names upfront.
 
     - Parameter forClassNames: A dictionary containing the logLevels for class names.
*/
    public static func registerLogLevel(forClassNames classNames: [String: DDLogLevel]) {
        if var logLevelDefaults = allLogLevelDefaults {
            for (key, value) in classNames {
                logLevelDefaults[key] = value.rawValue
            }
            UserDefaults().setVolatileDomain(logLevelDefaults, forName: LogManagerConstants.DefaultsName)
        }
    }
}

private extension LogManager {
    static var allLogLevelDefaults: [String:UInt]? {
        return UserDefaults().volatileDomain(forName: LogManagerConstants.DefaultsName) as? [String:UInt]
    }
}

extension DDLogLevel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .debug: return   "Debug"
        case .error: return   "Error"
        case .info: return    "Info"
        case .verbose: return "Verbose"
        case .warning: return "Warning"
        case .all: return     "All"
        case .off: return     "Off"
        }
    }
}
