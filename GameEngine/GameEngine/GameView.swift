//
//  GameView.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


open class GameView: MTKView {
    let renderer: Renderer = Renderer()
    public var scene: Scene? {
        get { return renderer.scene }
        set {
            renderer.scene = newValue
            renderer.mtkView(self, drawableSizeWillChange: self.drawableSize)
        }
    }

    public init(frame: CGRect) {
        super.init(frame: frame, device: Metal.device)
        colorPixelFormat = .bgra8Unorm
        depthStencilPixelFormat = .depth32Float
        preferredFramesPerSecond = 60
        clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        delegate = renderer

        #if os(iOS)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))

        addGestureRecognizer(pan)
        addGestureRecognizer(pinch)
        #endif
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS)
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        Mouse.ScrollMouse(deltaY: Float(gesture.velocity * 0.5))
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let location = float2(Float(gesture.location(in: self).x),
                              Float(gesture.location(in: self).y))
        let delta = float2(Float(translation.x),
                           Float(translation.y))

        gesture.setTranslation(.zero, in: gesture.view)

        Mouse.SetMousePositionChange(overallPosition: location,
                                     deltaPosition: delta)
    }
    #endif

    #if os(OSX)
    open override var acceptsFirstResponder: Bool { return true }

    open override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        print("first mouse")
        return true
    }

    open override func keyDown(with event: NSEvent) {
        Keyboard.setKeyPressed(event.keyCode, isOn: true)
    }

    open override func keyUp(with event: NSEvent) {
        Keyboard.setKeyPressed(event.keyCode, isOn: false)
    }

    open override func mouseDown(with event: NSEvent) {
        Mouse.SetMouseButtonPressed(button: event.buttonNumber, isOn: true)
    }

    open override func mouseUp(with event: NSEvent) {
        Mouse.SetMouseButtonPressed(button: event.buttonNumber, isOn: false)
    }

    open override func mouseDragged(with event: NSEvent) {
        Mouse.SetMousePositionChange(overallPosition: float2(Float(event.locationInWindow.x), Float(event.locationInWindow.y)),
                                     deltaPosition: float2(Float(event.deltaX), Float(event.deltaY)))
    }

    override open func scrollWheel(with event: NSEvent) {
        Mouse.ScrollMouse(deltaY: Float(event.deltaY))
    }
    #endif
}
