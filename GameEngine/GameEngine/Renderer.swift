//
//  Renderer.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


// Platform independent renderer class
class Renderer: NSObject {
    private let depthStencilState = createDepthState()!
    private var uniforms = Uniforms()
    private var fragmentUniforms = FragmentUniforms()
    var scene: Scene? {
        didSet {
            scene?.start()
        }
    }

    static func createDepthState() -> MTLDepthStencilState? {
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true

        return Metal.device.makeDepthStencilState(descriptor: depthDescriptor)
    }

    static func createRenderPipeline(vertexFunctionName: String, textures: Textures) -> MTLRenderPipelineState {
        let functionConstants = MTLFunctionConstantValues()
        var property = textures.baseColor != nil
        functionConstants.setConstantValue(&property,
                                           type: .bool,
                                           index: 0)

        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm //view.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float //view.depthStencilPixelFormat
        pipelineStateDescriptor.vertexFunction =  Metal.library.makeFunction(name: vertexFunctionName)
        pipelineStateDescriptor.fragmentFunction = try! Metal.library.makeFunction(name: "fragment_main", constantValues: functionConstants)
        pipelineStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()

        return try! Metal.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }
}


extension Renderer: MTKViewDelegate {

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("size: \(size)")
        guard var camera = scene?.camera else {
            return
        }
        
        camera.aspect = Float(size.width / size.height)
    }

    func draw(in view: MTKView) {
        guard
            let scene = scene,
            let camera = scene.camera,
            let commandBuffer = Metal.commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
            let drawable = view.currentDrawable
            else { return }

        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        scene.update(with: deltaTime)

        commandEncoder.setDepthStencilState(depthStencilState)

        uniforms.viewMatrix = camera.viewMatrix
        uniforms.projectionMatrix = camera.projectionMatrix
        fragmentUniforms.cameraPosition = camera.transform.position

        commandEncoder.setFragmentBytes(&fragmentUniforms,
                                        length: MemoryLayout<FragmentUniforms>.stride,
                                        index: 22)

        for renderable in scene.renderables {
            commandEncoder.pushDebugGroup(renderable.name)

            uniforms.modelMatrix = renderable.transform.worldMatrix
            commandEncoder.setVertexBytes(&uniforms,
                                          length: MemoryLayout<Uniforms>.stride,
                                          index: 21)

            renderable.render(commandEncoder: commandEncoder)
            commandEncoder.popDebugGroup()
        }

        commandEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

}
