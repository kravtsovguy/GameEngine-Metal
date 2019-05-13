//
//  GameViewController.swift
//  GameEngine iOS & tvOS
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
/// Generic View Controller Alias
public typealias PlatformViewController = UIViewController
#elseif os(OSX)
import AppKit
/// Generic View Controller Alias
public typealias PlatformViewController = NSViewController
#endif


/// Platform independent view controller
open class GameViewController: PlatformViewController {
    public var gameView: GameView {
        return view as! GameView
    }

    open override func loadView() {
        var frame = CGRect(origin: .zero, size: .zero)

        #if os(OSX)
        frame.size = AppDelegate.viewControllerSize
        #endif

        self.view = GameView(frame: frame)
    }
}
