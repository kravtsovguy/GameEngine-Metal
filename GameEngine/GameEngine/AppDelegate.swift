//
//  AppDelegate.swift
//  GameEngine iOS & tvOS
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
/// Generic App Delegate Alias
public typealias PlatformAppDelegate = UIResponder & UIApplicationDelegate
#elseif os(OSX)
import AppKit
/// Generic App Delegate Alias
public typealias PlatformAppDelegate = NSObject & NSApplicationDelegate
#endif


open class AppDelegate: PlatformAppDelegate {

    // MARK: Begin Shared
    open func setupAppDelegate() {
        // override
    }
    // MARK: End Shared


    #if os(iOS) || os(tvOS)
    public var window: UIWindow?

    open func application(_ application: UIApplication,
                          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        defer {
            self.setupAppDelegate()
        }

        let window = UIWindow()
        window.rootViewController = Main.parameters.viewControllerType.init()
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

    #elseif os(OSX)
    public var window : NSWindow?

    open func applicationDidFinishLaunching(_ aNotification: Notification) {
        defer {
            self.setupAppDelegate()
        }

        let screenFrame = NSScreen.main!.frame
        let width = Main.parameters.windowSizeMacOS.width
        let height = Main.parameters.windowSizeMacOS.height
        let x = (screenFrame.width - width) / 2
        let y = (screenFrame.height - height) / 2
        let rect = NSMakeRect(x, y, width, height);
        let window = NSWindow(contentRect: rect,
                              styleMask: [.titled, .resizable, .closable],
                              backing: NSWindow.BackingStoreType.buffered,
                              defer: false)

        window.contentViewController = Main.parameters.viewControllerType.init()
        window.makeKeyAndOrderFront(NSApp)

        self.window = window
    }

    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    #endif
}
