//
//  PlaneModelComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit

open class PlaneModelComponent: Component {
    var name: String
    var material: Material
//    let pipelineState: MTLRenderPipelineState
//    let buffer: MTLBuffer
//    let indexBuffer: MTLBuffer
    let color: float3 = [0.5, 0.5, 0.5]
    var mesh: Mesh!
    
//    let points: [float3] = [
//        [-0.5, 0, 0.5],
//        [-0.5, 0, -0.5],
//        [0.5, 0, 0.5],
//        [0.5, 0, -0.5],
//    ]

    let points: [Vertex] = [
        Vertex(position: [-0.5, 0,  0.5], normal: [0, 1, 0], uv: [0, 1]),
        Vertex(position: [-0.5, 0, -0.5], normal: [0, 1, 0], uv: [0, 0]),
        Vertex(position: [0.5 , 0,  0.5], normal: [0, 1, 0], uv: [1, 1]),
        Vertex(position: [0.5 , 0, -0.5], normal: [0, 1, 0], uv: [1, 0]),
    ]

    let indices: [UInt16] = [
        0, 1, 2,
        2, 1, 3,
    ]


    public init(with name: String) {
        self.name = name
//        self.pipelineState = Renderer.createDefaultRenderPipeline()
        self.material = Material(baseColor: color, specularColor: color, shininess: 1)
//        self.buffer = Renderer.device.makeBuffer(bytes: points, length: points.count * MemoryLayout<Vertex>.stride, options: [])!
//        self.indexBuffer = Renderer.device.makeBuffer(bytes: indecies, length: indecies.count * MemoryLayout<UInt16>.stride, options: [])!

        let allocator = MTKMeshBufferAllocator(device: Renderer.device)

        let vertexBuffer = allocator.newBuffer(MemoryLayout<Vertex>.stride * points.count, type: .vertex)
        let vertexMap = vertexBuffer.map()
        vertexMap.bytes.assumingMemoryBound(to: Vertex.self).assign(from: points, count: points.count)

        let indexBuffer = allocator.newBuffer(MemoryLayout<UInt16>.stride * indices.count, type: .index)
        let indexMap = indexBuffer.map()
        indexMap.bytes.assumingMemoryBound(to: UInt16.self).assign(from: indices, count: indices.count)

        let submesh = MDLSubmesh(indexBuffer: indexBuffer,
                                 indexCount: indices.count,
                                 indexType: .uint16,
                                 geometryType: .triangles,
                                 material: MDLMaterial(material: material))

        let mdlMesh = MDLMesh(vertexBuffer: vertexBuffer,
                              vertexCount: points.count,
                              descriptor: MDLVertexDescriptor.defaultVertexDescriptor(),
                              submeshes: [submesh])

        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: Renderer.device)
        self.mesh = Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)
        
//        allocator.newBuffer(with: poi, type: .vertex)

//        let indexData = Data(buffer: indexBuffer.contents())
//        let meshBuffer = MDLMeshBuffer()
//        meshBuffer.

//        let submesh = MDLSubmesh(indexBuffer: indexBuffer, indexCount: indecies.count, indexType: .uint16, geometryType: .triangles, material: Material(material: material))
//        MDLMesh(vertexBuffer: <#T##MDLMeshBuffer#>, vertexCount: <#T##Int#>, descriptor: <#T##MDLVertexDescriptor#>, submeshes: <#T##[MDLSubmesh]#>)
        super.init()
    }
}

extension PlaneModelComponent: Renderable {

    func render(commandEncoder: MTLRenderCommandEncoder) {
        for vertexBuffer in mesh.mtkMesh.vertexBuffers {
            //            commandEncoder.setRenderPipelineState(pipelineState)


            commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            //            commandEncoder.setFragmentTexture(nil, index: 0)


            for submesh in mesh.submeshes {
                let mtkSubmesh = submesh.mtkSubmesh
                var material = submesh.material
                commandEncoder.setRenderPipelineState(submesh.pipelineState)
                commandEncoder.setFragmentBytes(&material,
                                                length: MemoryLayout<Material>.stride,
                                                index: 11)
                commandEncoder.setFragmentTexture(submesh.textures.baseColor, index: 0)

                commandEncoder.drawIndexedPrimitives(type: .triangle,
                                                     indexCount: mtkSubmesh.indexCount,
                                                     indexType: mtkSubmesh.indexType,
                                                     indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                                     indexBufferOffset: mtkSubmesh.indexBuffer.offset)
            }
        }
    }

//    func render(commandEncoder: MTLRenderCommandEncoder) {
//        var material = self.material
//        commandEncoder.setRenderPipelineState(self.pipelineState)
//        commandEncoder.setVertexBuffer(self.buffer, offset: 0, index: 0)
//        commandEncoder.setFragmentBytes(&material,
//                                        length: MemoryLayout<Material>.stride,
//                                        index: 11)
//        commandEncoder.setFragmentTexture(nil, index: 0)
//
//
//        commandEncoder.drawIndexedPrimitives(type: .triangle,
//                                             indexCount: self.indecies.count,
//                                             indexType: .uint16,
//                                             indexBuffer: self.indexBuffer,
//                                             indexBufferOffset: 0)
//    }
}
