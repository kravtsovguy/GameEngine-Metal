//
//  AppDelegate.swift
//  GameEngine iOS & tvOS
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


#if os(iOS) || os(tvOS)
import UIKit


public class AppDelegate: UIResponder, UIApplicationDelegate {
    public static var viewControllerType: GameViewController.Type = GameViewController.self
    lazy var viewController: GameViewController = {
        return AppDelegate.viewControllerType.init()
    }()

    public var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()

        window.rootViewController = self.viewController
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

}

#elseif os(OSX)
import Cocoa


public class AppDelegate: NSObject, NSApplicationDelegate {
    public static var viewControllerType: GameViewController.Type = GameViewController.self
    public static var viewControllerSize: NSSize = NSSize(width: 800, height: 600)

    lazy var viewController: GameViewController = {
        let viewController = AppDelegate.viewControllerType.init()
        viewController.initialSize = AppDelegate.viewControllerSize

        return viewController
    }()

    var window : NSWindow?

    public func applicationDidFinishLaunching(_ aNotification: Notification) {
        let screenFrame = NSScreen.main!.frame
        let width = AppDelegate.viewControllerSize.width
        let height = AppDelegate.viewControllerSize.height
        let x = (screenFrame.width - width) / 2
        let y = (screenFrame.height - height) / 2
        let rect = NSMakeRect(x, y, width, height);
        let window = NSWindow(contentRect: rect,
                              styleMask: [.titled, .resizable, .closable],
                              backing: NSWindow.BackingStoreType.buffered,
                              defer: false)

        window.contentViewController = self.viewController
        window.makeKeyAndOrderFront(NSApp)

        self.window = window
    }

    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}
#endif

