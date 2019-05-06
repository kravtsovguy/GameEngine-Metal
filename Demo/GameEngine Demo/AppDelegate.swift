//
//  AppDelegate.swift
//  GameEngine iOS & tvOS
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


#if os(iOS) || os(tvOS)
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()

        let gameController = GameViewController(nibName: nil, bundle: nil)
        gameController.scene = MainScene()
        window.rootViewController = gameController
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

}

#elseif os(OSX)
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window : NSWindow?
    let width: CGFloat = 800
    let height: CGFloat = 600

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let screenFrame = NSScreen.main!.frame
        let x = (screenFrame.width - width) / 2
        let y = (screenFrame.height - height) / 2
        let rect = NSMakeRect(x, y, width, height);
        let window = NSWindow(contentRect: rect,
                              styleMask: [.titled, .resizable, .closable],
                              backing: NSWindow.BackingStoreType.buffered,
                              defer: false)

        let gameController = GameViewController(nibName: nil, bundle: nil)
        gameController.initialSize = rect.size
        gameController.scene = MainScene()
        window.contentViewController = gameController
        window.makeKeyAndOrderFront(NSApp)

        self.window = window
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}
#endif

