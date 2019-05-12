//
//  PerspectiveCamera.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


open class PerspsectiveCamera: CameraComponent {

//    var viewMatrix: float4x4 {
//        let translationMatrix = float4x4(translation: transform.position)
//        let rotationMatrix = float4x4(rotation: transform.rotation)
//
//        return (translationMatrix * rotationMatrix).inverse
//    }

    public var viewMatrix: float4x4 {
        let translationMatrix = float4x4(translation: transform.position)
        let rotationMatrix = float4x4(rotation: transform.rotation)

        return (translationMatrix * rotationMatrix).inverse
    }


    public var fov = radians(fromDegrees: 70)
    public var near: Float = 0.1
    public var far: Float = 100
    public var aspect: Float = 1

    public var projectionMatrix: float4x4 {
        return float4x4(projectionFov: fov,
                        near: near,
                        far: far,
                        aspect: aspect)
    }

    public func zoom(delta: Float) {
    }

    public func rotate(delta: float2) {
    }
}


open class ArcballCamera: PerspsectiveCamera {
    public var distance: Float = 0
    public var target = float3(repeating: 0)

    override public var viewMatrix: float4x4 {
        let translateMatrix = float4x4(translation: [target.x, target.y, target.z - distance])
        let rotateMatrix = float4x4(rotationYXZ: [-transform.rotation.x,
                                                  transform.rotation.y,
                                                  0])

        let matrix = (rotateMatrix * translateMatrix).inverse
        transform.position = rotateMatrix.upperLeft * -matrix.columns.3.xyz
        return matrix
    }

    override public func zoom(delta: Float) {
        let sensitivity: Float = 0.05
        distance -= delta * sensitivity
    }

    override public func rotate(delta: float2) {
        let sensitivity: Float = 0.005
        transform.rotation.y += delta.x * sensitivity
        transform.rotation.x += delta.y * sensitivity
        transform.rotation.x = max(-Float.pi/2, min(transform.rotation.x, Float.pi/2))
    }
}
