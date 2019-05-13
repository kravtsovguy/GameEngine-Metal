//
//  main.swift
//  GameEngine-Demo
//
//  Created by Matvey Kravtsov on 12/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


// setting viewController class
AppDelegate.viewControllerType = GameViewController.self


#if os(iOS) || os(tvOS)
import UIKit

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))

#elseif os(OSX)
import Cocoa

// setting macOS initial window size
AppDelegate.viewSize = NSSize(width: 800, height: 600)

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
#endif

