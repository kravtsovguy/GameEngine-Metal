//
//  Camera.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import simd


open class Camera: Component {

    var viewMatrix: float4x4 {
        let translationMatrix = float4x4(translation: transform.position)
        let rotationMatrix = float4x4(rotation: transform.rotation)

        return (translationMatrix * rotationMatrix).inverse
    }


    var fov = radians(fromDegrees: 70)
    var near: Float = 0.1
    var far: Float = 100
    var aspect: Float = 1

    var projectionMatrix: float4x4 {
        return float4x4(projectionFov: fov,
                        near: near,
                        far: far,
                        aspect: aspect)
    }

    func zoom(delta: Float) {}
    func rotate(delta: float2) {}
}


class ArcballCamera: Camera {
    var distance: Float = 0
    var target = float3(repeating: 0)

    override var viewMatrix: float4x4 {
        let translateMatrix = float4x4(translation: [target.x, target.y, target.z - distance])
        let rotateMatrix = float4x4(rotationYXZ: [-transform.rotation.x,
                                                  transform.rotation.y,
                                                  0])

        let matrix = (rotateMatrix * translateMatrix).inverse
        transform.position = rotateMatrix.upperLeft * -matrix.columns.3.xyz
        return matrix
    }

    override func zoom(delta: Float) {
        let sensitivity: Float = 0.05
        distance -= delta * sensitivity
    }

    override func rotate(delta: float2) {
        let sensitivity: Float = 0.005
        transform.rotation.y += delta.x * sensitivity
        transform.rotation.x += delta.y * sensitivity
        transform.rotation.x = max(-Float.pi/2, min(transform.rotation.x, Float.pi/2))
    }
}
