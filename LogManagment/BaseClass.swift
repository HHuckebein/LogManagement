//
//  BaseClass.swift
//  LogManagment
//
//  Created by Bernd Rabe on 10.09.16.
//  Copyright © 2016 RABE_IT Services. All rights reserved.
//

import Foundation
import CocoaLumberjack

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

