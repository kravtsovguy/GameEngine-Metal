//
//  Renderer.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


/// Platform independent renderer class
final class Renderer: NSObject {
    let depthStencilState = createDepthState()!
    private(set) var uniforms = Uniforms()
    private(set) var fragmentUniforms = FragmentUniforms()
    private var lastRenderTime: CFAbsoluteTime?
    private let mainPass: RendererPassProtocol = MainRendererPass()
    var renderPasses: [RendererPassProtocol] = []
    var scene: Scene? {
        didSet {
            lastRenderTime = nil
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

    final func render(commandBuffer: MTLCommandBuffer, renderPass: RendererPassProtocol, renderables: [Renderable]) {
        renderPass.setup(commandBuffer: commandBuffer)
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPass.renderPassDescriptor) else {
            return
        }

        commandEncoder.pushDebugGroup(String(describing:type(of: renderPass)))

        renderPass.setup(commandEncoder: commandEncoder, renderer: self)
        for renderable in renderables {
            commandEncoder.pushDebugGroup(renderable.name)

            uniforms.modelMatrix = renderable.transform.worldMatrix
            commandEncoder.setVertexBytes(&uniforms,
                                          length: MemoryLayout<Uniforms>.stride,
                                          index: 21)

            renderPass.render(commandEncoder: commandEncoder, renderable: renderable)
            commandEncoder.popDebugGroup()
        }

        commandEncoder.endEncoding()
        commandEncoder.popDebugGroup()

        renderPass.teardown(commandBuffer: commandBuffer)
        commandBuffer.addCompletedHandler(renderPass.commandBufferCompleted)
    }
}


extension Renderer: MTKViewDelegate {

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("drawable size: \(size)")
        guard let camera = scene?.cameraComponent else {
            return
        }
        
        camera.aspect = Float(size.width / size.height)

        for renderPass in renderPasses {
            renderPass.updateWithView(view: view)
        }
    }

    func draw(in view: MTKView) {
        guard
            let scene = scene,
            let camera = scene.cameraComponent,
            let commandBuffer = Metal.commandQueue.makeCommandBuffer(),
            let drawable = view.currentDrawable
            else { return }

        uniforms.viewMatrix = camera.viewMatrix
        uniforms.projectionMatrix = camera.projectionMatrix
        fragmentUniforms.cameraPosition = camera.transform.position

        mainPass.updateWithView(view: view)
        render(commandBuffer: commandBuffer, renderPass: mainPass, renderables: scene.renderables)

        for renderPass in renderPasses {
            render(commandBuffer: commandBuffer, renderPass: renderPass, renderables: scene.renderables)
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()

        if let lastRenderTime = self.lastRenderTime {
            let deltaTime = CFAbsoluteTimeGetCurrent() - lastRenderTime
            scene.update(with: Float(deltaTime))
        }
        lastRenderTime = CFAbsoluteTimeGetCurrent()
    }
}
