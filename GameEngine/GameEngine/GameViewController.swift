//
//  GameViewController.swift
//  GameEngine iOS & tvOS
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


#if os(iOS) || os(tvOS)
import UIKit
public typealias PlatformViewController = UIViewController
#elseif os(OSX)
import AppKit
public typealias PlatformViewController = NSViewController
#endif


// Platform independent view controller
open class GameViewController: PlatformViewController {
    let initialSize: CGSize?
    var renderer: Renderer!

    public convenience init() {
        self.init(with: nil)
    }

    public init(with size:CGSize?) {
        initialSize = size
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func loadView() {
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }

        let frame = CGRect(origin: CGPoint.zero, size: initialSize ?? CGSize.zero)
        let view = MTKView(frame: frame, device: defaultDevice)
        self.renderer = try! Renderer(metalKitView: view)

        self.view = view
    }
}
