//
//  Model.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation
import MetalKit

open class Model: Node {
    
    let mdlMeshes: [MDLMesh]
    let mtkMeshes: [MTKMesh]

    public required init(name: String) {
        let assetURL = Bundle.main.url(forResource: name, withExtension: "obj")
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor()
        let asset = MDLAsset(url: assetURL,
                             vertexDescriptor: vertexDescriptor,
                             bufferAllocator: allocator)

        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: Renderer.device)

        self.mdlMeshes = mdlMeshes
        self.mtkMeshes = mtkMeshes
        super.init()

        self.name = name
    }
}

extension Model: Renderable {
    func render(commandEncoder: MTLRenderCommandEncoder, uniforms vertex: Uniforms) {
        var uniforms = vertex

        uniforms.modelMatrix = worldMatrix

        commandEncoder.setVertexBytes(&uniforms,
                                      length: MemoryLayout<Uniforms>.stride,
                                      index: 21)

        for mtkMesh in mtkMeshes {
            for vertexBuffer in mtkMesh.vertexBuffers {

                commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                               offset: vertexBuffer.offset,
                                               index: 0)

                var colorID: UInt = 0

                for submesh in mtkMesh.submeshes {
                    commandEncoder.setVertexBytes(&colorID,
                                                  length: MemoryLayout<uint>.stride,
                                                  index: 20)
                    commandEncoder.drawIndexedPrimitives(type: .triangle,
                                                         indexCount: submesh.indexCount,
                                                         indexType: submesh.indexType,
                                                         indexBuffer: submesh.indexBuffer.buffer,
                                                         indexBufferOffset: submesh.indexBuffer.offset)

                    colorID += 1
                }
            }
        }
    }
}
