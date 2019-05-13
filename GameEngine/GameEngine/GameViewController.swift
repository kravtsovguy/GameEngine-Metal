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
    open var gameView: GameView {
        return view as! GameView
    }

    public var initialFrame: CGRect {
        var frame = CGRect(origin: .zero, size: .zero)

        #if os(iOS) || os(tvOS)
        frame.size = UIScreen.main.bounds.size
        #elseif os(OSX)
        frame.size = AppDelegate.viewSize
        #endif

        return frame
    }

    open override func loadView() {
        self.view = GameView(frame: initialFrame)
    }
}
