//
//  Renderer.swift
//  GameEngine Shared
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal
import MetalKit
import simd

struct Vertex {
    let position: float3
    let color : float3
}

// Platform independent renderer class
class Renderer: NSObject {
    internal static var device: MTLDevice!
    internal static var library: MTLLibrary!
    private let commandQueue: MTLCommandQueue
    private let depthStencilState: MTLDepthStencilState
    private var uniforms: Uniforms
    private var fragmentUniforms: FragmentUniforms
    var scene: Scene?

    required init(view: MTKView) {
        // init command queue and device
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
                fatalError("Unable to connect to GPU")
        }

        guard
            let resourcePath = Bundle.main.path(forResource: "ShadersLibrary", ofType: "metallib"),
            let defaultLibrary = try? device.makeLibrary(URL: URL(fileURLWithPath: resourcePath)) else {
                fatalError("Unable to load shaders library")
        }

        Renderer.device = device
        Renderer.library = defaultLibrary
        self.commandQueue = commandQueue
        self.depthStencilState = Renderer.createDepthState()

        uniforms = Uniforms()
        fragmentUniforms = FragmentUniforms()

        super.init()
    }

    static func createDepthState() -> MTLDepthStencilState {
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true

        return Renderer.device.makeDepthStencilState(descriptor: depthDescriptor)!
    }
}


extension Renderer: MTKViewDelegate {

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene?.camera.aspect = Float(view.bounds.width / view.bounds.height)
    }

    func draw(in view: MTKView) {
        guard
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
            let drawable = view.currentDrawable,
            let scene = scene,
            let camera = scene.camera
            else { return }

        commandEncoder.setDepthStencilState(depthStencilState)

        fragmentUniforms.cameraPosition = camera.transform.position
        uniforms.viewMatrix = camera.viewMatrix
        uniforms.projectionMatrix = camera.projectionMatrix

        for renderable in scene.renderables {
            commandEncoder.pushDebugGroup(renderable.name)
            renderable.render(commandEncoder: commandEncoder, uniforms: uniforms, fragmentUniforms: fragmentUniforms)
            commandEncoder.popDebugGroup()
        }

        commandEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

}
