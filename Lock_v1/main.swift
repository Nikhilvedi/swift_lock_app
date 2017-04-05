//
//  main.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 03/02/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import Foundation

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(FLApplication.self),
    NSStringFromClass(AppDelegate.self)
)
