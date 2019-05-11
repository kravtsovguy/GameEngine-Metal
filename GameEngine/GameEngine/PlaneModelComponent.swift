//
//  PlaneModelComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal

open class PlaneModelComponent: Component {
    var name: String
    var material: Material
    let pipelineState: MTLRenderPipelineState
    let buffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let color: float3 = [0.5, 0.5, 0.5]
    
//    let points: [float3] = [
//        [-0.5, 0, 0.5],
//        [-0.5, 0, -0.5],
//        [0.5, 0, 0.5],
//        [0.5, 0, -0.5],
//    ]

    let points: [Vertex] = [
        Vertex(position: [-0.5, 0, 0.5],    normal: [0, 1, 0]),
        Vertex(position: [-0.5, 0, -0.5],   normal: [0, 1, 0]),
        Vertex(position: [0.5, 0, 0.5],     normal: [0, 1, 0]),
        Vertex(position: [0.5, 0, -0.5],    normal: [0, 1, 0]),
    ]

    let indecies: [uint16] = [
        0, 1, 2,
        2, 1, 3,
    ]


    public init(with name: String) {
        self.name = name
        self.pipelineState = Renderer.createSimpleRenderPipeline()!
        self.material = Material(baseColor: color, specularColor: color, shininess: 1)
        self.buffer = Renderer.device.makeBuffer(bytes: points, length: points.count * MemoryLayout<Vertex>.stride, options: [])!
        self.indexBuffer = Renderer.device.makeBuffer(bytes: indecies, length: indecies.count * MemoryLayout<uint16>.stride, options: [])!
        super.init()
    }
}

extension PlaneModelComponent: Renderable {

    func render(commandEncoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms, fragmentUniforms fragment: FragmentUniforms) {
        var uniforms = vertex
        var fragmentUniforms = fragment

        uniforms.modelMatrix = transform.worldMatrix
        commandEncoder.setVertexBytes(&uniforms,
                                      length: MemoryLayout<Uniforms>.stride,
                                      index: 21)
        commandEncoder.setFragmentBytes(&fragmentUniforms,
                                        length: MemoryLayout<FragmentUniforms>.stride,
                                        index: 22)

        commandEncoder.setRenderPipelineState(self.pipelineState)

        commandEncoder.setVertexBuffer(self.buffer, offset: 0, index: 0)

        var material = self.material
        commandEncoder.setFragmentBytes(&material,
                                        length: MemoryLayout<Material>.stride,
                                        index: 11)

        commandEncoder.setFragmentTexture(nil, index: 0)


        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: self.indecies.count,
                                             indexType: .uint16,
                                             indexBuffer: self.indexBuffer,
                                             indexBufferOffset: 0)
    }
}
