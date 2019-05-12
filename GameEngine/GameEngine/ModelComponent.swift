//
//  ModelComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation
import MetalKit

open class ModelComponent: Component {
//    let name: String
//    private var meshes: [Mesh]!

//    public init(name: String) {
//        self.name = name
//        super.init()
//    }

    var name: String {
        return model.name
    }

    let model: Model

    public init(model: Model) {
        self.model = model
        super.init()
    }


//    override func start() {
//        let assetURL = Bundle.main.url(forResource: name, withExtension: "obj")
//        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
//        let vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor()
//        let asset = MDLAsset(url: assetURL,
//                             vertexDescriptor: vertexDescriptor,
//                             bufferAllocator: allocator)
//
//        asset.loadTextures()
//
//        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: Renderer.device)
//        self.meshes = zip(mdlMeshes, mtkMeshes).map {
//            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
//        }
//    }

    func render(commandEncoder: MTLRenderCommandEncoder, submesh: Submesh) {
        let mtkSubmesh = submesh.mtkSubmesh
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: mtkSubmesh.indexCount,
                                             indexType: mtkSubmesh.indexType,
                                             indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                             indexBufferOffset: mtkSubmesh.indexBuffer.offset)
    }
}

extension ModelComponent: Renderable {

    func render(commandEncoder: MTLRenderCommandEncoder) {
        for mesh in model.meshes {
            for vertexBuffer in mesh.mtkMesh.vertexBuffers {

                commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)

                for submesh in mesh.submeshes {
                    commandEncoder.setRenderPipelineState(submesh.pipelineState)
                    var material = submesh.material
                    commandEncoder.setFragmentBytes(&material,
                                                    length: MemoryLayout<Material>.stride,
                                                    index: 11)
                    commandEncoder.setFragmentTexture(submesh.textures.baseColor, index: 0)

                    render(commandEncoder: commandEncoder, submesh: submesh)
                }
            }
        }
    }
}
