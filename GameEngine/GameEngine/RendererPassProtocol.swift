//
//  RendererPassProtocol.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit

public protocol RendererPassProtocol {

    var renderPassDescriptor: MTLRenderPassDescriptor { get }

    func setup(commandBuffer: MTLCommandBuffer)
    func setup(commandEncoder: MTLRenderCommandEncoder, renderer: Renderer)
    func teardown(commandBuffer: MTLCommandBuffer)
    func render(commandEncoder: MTLRenderCommandEncoder, renderable: Renderable)
    func commandBufferCompleted(commandBuffer: MTLCommandBuffer)
    func updateWithView(view: MTKView)
}
