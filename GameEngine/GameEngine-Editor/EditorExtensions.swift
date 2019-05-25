//
//  EditorExtensions.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit
import GameEngine


fileprivate extension UInt8 {
    static var length: UInt {
        return 256
    }
}

precedencegroup ExponentiationPrecedence { associativity: right higherThan: MultiplicationPrecedence }
infix operator ^^: ExponentiationPrecedence

fileprivate func ^^<T : BinaryInteger>(base: T, power: Int) -> T {
    if power < 0 { return 0 }
    var power = power
    var result: T = 1
    var square = base

    if power > 0 {
        if power % 2 == 1 { result *= square }
        power /= 2
    }
    while power > 0 {
        square *= square
        if power % 2 == 1 { result *= square }
        power /= 2
    }
    return result
}

extension ModelComponent: EditorRenderable {

    var editorColor: EditorRendererPass.PixelColor {
        return EditorRendererPass.PixelColor(blue:  UInt8(id / UInt8.length ^^ 0 % UInt8.length),
                                             green: UInt8(id / UInt8.length ^^ 1 % UInt8.length),
                                             red:   UInt8(id / UInt8.length ^^ 2 % UInt8.length),
                                             alpha: UInt8.max)
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
