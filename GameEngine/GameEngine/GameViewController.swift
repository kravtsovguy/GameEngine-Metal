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
    var metalView: MTKView! { return view as? MTKView }

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
    
    open override func loadView() {
        let frame = CGRect(origin: CGPoint.zero, size: initialSize ?? CGSize.zero)
        let view = MTKView(frame: frame)
        view.colorPixelFormat = .bgra8Unorm
        view.depthStencilPixelFormat = .depth32Float
        view.preferredFramesPerSecond = 60
        view.clearColor = MTLClearColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)

        self.view = view
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        renderer = Renderer(view: metalView)
        renderer.scene = MainScene()
        metalView.device = Renderer.device
        metalView.delegate = renderer
    }
}
