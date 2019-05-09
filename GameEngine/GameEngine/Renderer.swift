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
    static let device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Unable to connect to GPU")
        }

        return device
    }()

     static let library: MTLLibrary = {
        guard
            let resourcePath = Bundle.main.path(forResource: "ShadersLibrary", ofType: "metallib"),
            let defaultLibrary = try? device.makeLibrary(URL: URL(fileURLWithPath: resourcePath)) else {
                fatalError("Unable to load shaders library")
        }
        return defaultLibrary
    }()
    private let commandQueue = device.makeCommandQueue()!
    private let depthStencilState = createDepthState()!
    private var uniforms = Uniforms()
    private var fragmentUniforms = FragmentUniforms()
    var scene: Scene! {
        didSet {
            scene?.start()
        }
    }

    static func createDepthState() -> MTLDepthStencilState? {
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true

        return device.makeDepthStencilState(descriptor: depthDescriptor)
    }

    static func createRenderPipeline(vertexFunctionName: String, textures: Textures) -> MTLRenderPipelineState? {
        let functionConstants = MTLFunctionConstantValues()
        var property = textures.baseColor != nil
        functionConstants.setConstantValue(&property,
                                           type: .bool,
                                           index: 0)

        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm //view.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float //view.depthStencilPixelFormat
        pipelineStateDescriptor.vertexFunction =  library.makeFunction(name: vertexFunctionName)
        pipelineStateDescriptor.fragmentFunction = try! library.makeFunction(name: "fragment_main", constantValues: functionConstants)
        pipelineStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()

        return try? Renderer.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }

    static func createSimpleRenderPipeline() -> MTLRenderPipelineState? {
        let functionConstants = MTLFunctionConstantValues()
        var property = false
        functionConstants.setConstantValue(&property,
                                           type: .bool,
                                           index: 0)

        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm //view.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float //view.depthStencilPixelFormat
        pipelineStateDescriptor.vertexFunction =  library.makeFunction(name: "vertex_main")
        pipelineStateDescriptor.fragmentFunction = try! library.makeFunction(name: "fragment_main", constantValues: functionConstants)
        pipelineStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()

        return try? Renderer.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }
}


extension Renderer: MTKViewDelegate {

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("size: \(size)")
        scene.camera.aspect = Float(size.width / size.height)
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

        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        scene.update(with: deltaTime)

        commandEncoder.setDepthStencilState(depthStencilState)

        uniforms.viewMatrix = camera.viewMatrix
        uniforms.projectionMatrix = camera.projectionMatrix
        fragmentUniforms.cameraPosition = camera.transform.position

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
