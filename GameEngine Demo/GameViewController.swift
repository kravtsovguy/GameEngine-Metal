//
//  GameViewController.swift
//  GameEngine iOS & tvOS
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit
import GameEngine


#if os(iOS) || os(tvOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(OSX)
import AppKit
typealias PlatformViewController = NSViewController
#endif


// Platform independent view controller
class GameViewController: PlatformViewController {
    var renderer: Renderer!

    override func loadView() {
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }

        #if os(iOS) || os(tvOS)
        let frame = CGRect.zero
        #elseif os(OSX)
        let frame = NSApp.keyWindow!.contentView!.bounds
        #endif

        let view = MTKView(frame: frame, device: defaultDevice)
        self.renderer = try! Renderer(metalKitView: view)

        self.view = view
    }
}
