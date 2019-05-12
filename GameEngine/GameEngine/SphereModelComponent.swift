//
//  SphereModelComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 11/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit

open class SphereModelComponent: Component {
    var name: String
//    var material: Material
    let color: float3 = [0.5, 0.5, 0.5]
//    let pipelineState: MTLRenderPipelineState
    var mesh: Mesh!

    public init(with name: String) {
        self.name = name
//        self.pipelineState = Renderer.createDefaultRenderPipeline()!
//        self.material = Material(baseColor: color, specularColor: color, shininess: 1)
        super.init()
    }

    override func start() {
        let material = Material(baseColor: color, specularColor: color, shininess: 1)
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let mdlMesh = MDLMesh(sphereWithExtent: [1, 1, 1],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: .triangles,
                              allocator: allocator)

        mdlMesh.vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor()
        mdlMesh.submeshes?.forEach {
            if let submesh = $0 as? MDLSubmesh {
                submesh.material = MDLMaterial(material: material)
            }
        }

        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: Renderer.device)
        self.mesh = Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)
    }
}

extension SphereModelComponent: Renderable {

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
}
