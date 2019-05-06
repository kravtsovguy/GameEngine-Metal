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
        view.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)

        self.view = view
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        renderer = Renderer(view: metalView)
        renderer.scene = MainScene()
        metalView.device = Renderer.device
        metalView.delegate = renderer

        #if os(iOS)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))

        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(pinch)
        #endif

        #if os(OSX)
        let pan = NSPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
        #endif
    }

    #if os(iOS)
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        renderer.scene?.camera.zoom(delta: Float(gesture.velocity * 0.5))
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let delta = float2(Float(translation.x),
                           -Float(translation.y))

        renderer.scene?.camera.rotate(delta: delta)
        gesture.setTranslation(.zero, in: gesture.view)
    }
    #endif

    #if os(OSX)
    override open func scrollWheel(with event: NSEvent) {
        renderer.scene?.camera.zoom(delta: Float(event.deltaY))
    }

    @objc func handlePan(gesture: NSPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let delta = float2(Float(translation.x),
                           Float(translation.y))

        renderer.scene?.camera.rotate(delta: delta)
        gesture.setTranslation(.zero, in: gesture.view)
    }
    #endif
}
