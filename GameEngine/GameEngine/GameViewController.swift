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
        frame.size = UIApplication.shared.keyWindow!.frame.size
        #elseif os(OSX)
        frame.size = NSApplication.shared.keyWindow!.frame.size
        #endif

        return frame
    }

    open override func loadView() {
        self.view = Main.parameters.viewType.init(frame: initialFrame)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        gameView.scene = Main.parameters.sceneType?.init()
    }
}
