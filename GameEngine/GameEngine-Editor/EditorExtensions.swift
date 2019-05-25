//
//  EditorExtensions.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


extension ModelComponent: EditorRenderable {

    var editorColor: EditorRendererPass.PixelColor {
        return EditorRendererPass.PixelColor(blue: UInt8(id / UInt(powf(256, 0)) % 256),
                                             green: UInt8(id / UInt(powf(256, 1)) % 256),
                                             red: UInt8(id / UInt(powf(256, 2)) % 256),
                                             alpha: 255)
    }

    func renderEditor(commandEncoder: MTLRenderCommandEncoder) {
        for mesh in model.meshes {
            for vertexBuffer in mesh.mtkMesh.vertexBuffers {

                commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)

                for submesh in mesh.submeshes {

                    var color = editorColor.float3
                    commandEncoder.setFragmentBytes(&color,
                                                    length: MemoryLayout<float3>.stride,
                                                    index: 12)

                    render(commandEncoder: commandEncoder, submesh: submesh)
                }
            }
        }
    }
    
}
