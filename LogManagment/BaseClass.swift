//
//  BaseClass.swift
//  LogManagment
//
//  Created by Bernd Rabe on 10.09.16.
//  Copyright © 2016 RABE_IT Services. All rights reserved.
//

import Foundation
import CocoaLumberjack

extension BaseClass: LogLevel {
    public var logLevel: DDLogLevel {
        return LogManager.logLevel(forClassName: String(describing: type(of: self)))
    }
}

class BaseClass {
    
}

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
