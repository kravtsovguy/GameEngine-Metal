//
//  Extensions.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit

extension Renderable {
    var editorColor: EditorRendererPass.PixelColor {
        return EditorRendererPass.PixelColor(blue: UInt8(1 * id % 256),
                                             green: UInt8(2 * id % 256),
                                             red: UInt8(3 * id % 256),
                                             alpha: 255)
    }


    var editorColorFloat: float3 {
        return [Float(editorColor.red) / Float(UInt8.max),
                Float(editorColor.green) / Float(UInt8.max),
                Float(editorColor.blue) / Float(UInt8.max)]
    }
}


extension ModelComponent {

    func renderEditor(commandEncoder: MTLRenderCommandEncoder) {
        for mesh in model.meshes {
            for vertexBuffer in mesh.mtkMesh.vertexBuffers {

                commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)

                for submesh in mesh.submeshes {

                    var color = editorColorFloat
                    commandEncoder.setFragmentBytes(&color,
                                                    length: MemoryLayout<float3>.stride,
                                                    index: 12)

                    render(commandEncoder: commandEncoder, submesh: submesh)
                }
            }
        }
    }
    
}
