//
//  MainRenderPass.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit

class MainRendererPass: RendererPassProtocol {
    var renderPassDescriptor: MTLRenderPassDescriptor = MTLRenderPassDescriptor()

    func setup(commandBuffer: MTLCommandBuffer) {
        
    }

    func setup(commandEncoder: MTLRenderCommandEncoder, renderer: Renderer) {
        commandEncoder.setDepthStencilState(renderer.depthStencilState)

        var fragmentUniforms = renderer.fragmentUniforms
        commandEncoder.setFragmentBytes(&fragmentUniforms,
                                 length: MemoryLayout<FragmentUniforms>.stride,
                                 index: 22)
    }

    func render(commandEncoder: MTLRenderCommandEncoder, renderable: Renderable) {
        renderable.render(commandEncoder: commandEncoder)
    }

    func teardown(commandBuffer: MTLCommandBuffer) {
        
    }

    func commandBufferCompleted(commandBuffer: MTLCommandBuffer) {

    }

    func updateWithView(view: MTKView) {
        renderPassDescriptor = view.currentRenderPassDescriptor!
    }
}
