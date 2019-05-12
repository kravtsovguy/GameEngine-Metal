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
/// Generic View Controller Alias
public typealias PlatformViewController = UIViewController
#elseif os(OSX)
import AppKit
/// Generic View Controller Alias
public typealias PlatformViewController = NSViewController
#endif


/// Platform independent view controller
open class GameViewController: PlatformViewController {
    let renderer: Renderer = Renderer()
    var mtkView: MTKView {
        return view as! MTKView
    }

    public var initialSize: CGSize? = nil
    public var scene: Scene? {
        get { return renderer.scene }
        set {
            renderer.scene = newValue

            #if os(OSX)
            let scaleFactor = NSScreen.main!.backingScaleFactor
            let size = CGSize(width: scaleFactor * view.frame.size.width,
                              height: scaleFactor * view.frame.size.height)
            renderer.mtkView(mtkView, drawableSizeWillChange: size)
            #endif
        }
    }

    open override func loadView() {
        let frame = CGRect(origin: CGPoint.zero, size: initialSize ?? .zero)
        let view = MTKView(frame: frame, device: Metal.device)
        view.colorPixelFormat = .bgra8Unorm
        view.depthStencilPixelFormat = .depth32Float
        view.preferredFramesPerSecond = 60
        view.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        view.delegate = renderer

        self.view = view
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

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
        scene?.camera.zoom(delta: Float(gesture.velocity * 0.5))
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let delta = float2(Float(translation.x),
                           -Float(translation.y))

        scene?.camera.rotate(delta: delta)
        gesture.setTranslation(.zero, in: gesture.view)
    }
    #endif

    #if os(OSX)
    override open func scrollWheel(with event: NSEvent) {
        scene?.camera.zoom(delta: Float(event.deltaY))
    }

    @objc func handlePan(gesture: NSPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let delta = float2(Float(translation.x),
                           Float(translation.y))

        scene?.camera.rotate(delta: delta)
        gesture.setTranslation(.zero, in: gesture.view)
    }
    #endif
}
