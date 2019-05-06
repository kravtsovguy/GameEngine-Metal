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

    let meshes: [Mesh]

    public required init(name: String) {
        let assetURL = Bundle.main.url(forResource: name, withExtension: "obj")
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor()
        let asset = MDLAsset(url: assetURL,
                             vertexDescriptor: vertexDescriptor,
                             bufferAllocator: allocator)

        asset.loadTextures()

        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: Renderer.device)
        self.meshes = zip(mdlMeshes, mtkMeshes).map {
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }

        super.init()
        self.name = name
    }
}

extension Model: Renderable {
    func render(commandEncoder: MTLRenderCommandEncoder,
                uniforms vertex: Uniforms,
                fragmentUniforms fragment: FragmentUniforms) {
        var uniforms = vertex
        var fragmentUniforms = fragment

        uniforms.modelMatrix = worldMatrix
        commandEncoder.setFragmentBytes(&fragmentUniforms,
                                        length: MemoryLayout<FragmentUniforms>.stride,
                                        index: 21);
        commandEncoder.setVertexBytes(&uniforms,
                                      length: MemoryLayout<Uniforms>.stride,
                                      index: 21)

        for mesh in meshes {
            for vertexBuffer in mesh.mtkMesh.vertexBuffers {

                commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                               offset: vertexBuffer.offset,
                                               index: 0)

                for submesh in mesh.submeshes {

                    var material = submesh.material
                    commandEncoder.setFragmentBytes(&material,
                                                    length: MemoryLayout<Material>.stride,
                                                    index: 20)
                    commandEncoder.setFragmentTexture(submesh.textures.baseColor, index: 0)

                    let mtkSubmesh = submesh.mtkSubmesh
                    commandEncoder.drawIndexedPrimitives(type: .triangle,
                                                         indexCount: mtkSubmesh.indexCount,
                                                         indexType: mtkSubmesh.indexType,
                                                         indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                                         indexBufferOffset: mtkSubmesh.indexBuffer.offset)
                }
            }
        }
    }
}
