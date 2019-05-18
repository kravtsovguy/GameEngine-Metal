//
//  Main.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public enum Main {

    public final class Parameters {

        public var windowSizeMacOS: CGSize = CGSize(width: 1200, height: 800)
        public var appDelegateType: AppDelegate.Type = AppDelegate.self
        public var viewControllerType: GameViewController.Type = GameViewController.self
        public var viewType: GameView.Type = GameView.self
        public var sceneType: Scene.Type?

        fileprivate init() { }
    }
    
    static var parameters: Parameters = Parameters()

    public static func start(_ argc: Int32 = CommandLine.argc,
                             _ argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?> = CommandLine.unsafeArgv,
                             builder:((Parameters)->())? = nil) {
        builder?(parameters)

        #if os(iOS) || os(tvOS)
        UIApplicationMain(argc, argv, nil, NSStringFromClass(parameters.appDelegateType))

        #elseif os(OSX)
        let app = NSApplication.shared
        let delegate = parameters.appDelegateType.init()
        app.delegate = delegate

        _ = NSApplicationMain(argc, argv)
        #endif
    }
}
