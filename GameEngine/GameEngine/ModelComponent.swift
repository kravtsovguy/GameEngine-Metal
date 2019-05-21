//
//  ModelComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


open class ModelComponent: Component {
    
    let model: Model
    var name: String { return model.name }
    private var editorColor: float3 =  float3.random(in: 0...1)
    
//    {
////        var random = SystemRandomNumberGenerator()
////        let r: UInt8 = random.next()
////        let g: UInt8 = random.next()
////        let b: UInt8 = random.next()
////        Float.random(in: 0...1)
//        float3.random(in: 0..1)
//        return [Float.random(in: 0...1), Float.random(in: 0...1), Float.random(in: 0...1)]
//    }()

    public init(model: Model) {
        self.model = model
        super.init()
    }

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

    func renderEditor(commandEncoder: MTLRenderCommandEncoder) {
        for mesh in model.meshes {
            for vertexBuffer in mesh.mtkMesh.vertexBuffers {

                commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)

                for submesh in mesh.submeshes {
                    commandEncoder.setFragmentBytes(&editorColor,
                                                    length: MemoryLayout<float3>.stride,
                                                    index: 12)

                    render(commandEncoder: commandEncoder, submesh: submesh)
                }
            }
        }
    }

}
