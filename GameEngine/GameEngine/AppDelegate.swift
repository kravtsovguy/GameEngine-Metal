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

    // MARK: Shared
    open func setup() {
        // override
    }

    // MARK: init
    required public override init() {
        super.init()
    }

    #if os(iOS) || os(tvOS)
    public var window: UIWindow?

    open func application(_ application: UIApplication,
                          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        defer {
            self.setup()
        }

        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = Main.parameters.viewControllerType.init()

        return true
    }

    #elseif os(OSX)
    public var window : NSWindow?

    open func applicationDidFinishLaunching(_ aNotification: Notification) {
        defer {
            self.setup()
        }

        window = NSWindow(contentRect: CGRect(origin: .zero, size: Main.parameters.windowSizeMacOS),
                          styleMask: [.titled, .resizable, .closable],
                          backing: .buffered,
                          defer: false)

        window?.makeKeyAndOrderFront(NSApp)
        window?.center()
        window?.contentViewController = Main.parameters.viewControllerType.init()
    }

    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    #endif
}
