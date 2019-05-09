//
//  PlaneNode.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal

class PlaneNode: Node {

    let pipelineState: MTLRenderPipelineState

    public init(name: String) {
        self.pipelineState = Renderer.createSimpleRenderPipeline()!
        super.init(with: name)
    }
}

extension PlaneNode: Renderable {

    func render(commandEncoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms, fragmentUniforms fragment: FragmentUniforms) {
//        var uniforms = vertex
//        var fragmentUniforms = fragment
//
//        uniforms.modelMatrix = transform.worldMatrix
//        commandEncoder.setVertexBytes(&uniforms,
//                                      length: MemoryLayout<Uniforms>.stride,
//                                      index: 21)
//        commandEncoder.setFragmentBytes(&fragmentUniforms,
//                                        length: MemoryLayout<FragmentUniforms>.stride,
//                                        index: 22)
    }
}
