//
//  main.swift
//  GameEngine-Demo
//
//  Created by Matvey Kravtsov on 12/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine
import CoreGraphics


// MARK: start
Main.start(CommandLine.argc, CommandLine.unsafeArgv) { parameters in
    // MARK: setting macOS initial window size
    parameters.windowSizeMacOS = CGSize(width: 800, height: 600)

    // MARK: setting scene
    parameters.sceneType = MainScene.self
}
