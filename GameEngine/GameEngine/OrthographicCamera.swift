//
//  OrthographicCamera.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


open class OrthographicCamera: CameraComponent {
    public let sizeHeight: Float = 5
    public var aspect: Float = 1
    var left: Float { return -aspect * sizeHeight}
    var right: Float { return aspect * sizeHeight}
    var top: Float { return sizeHeight }
    var bottom: Float { return -sizeHeight }
    public var near: Float = 0.3
    public var far: Float = 100

    public var projectionMatrix: float4x4 {
        let matrix = float4x4.orthographicMatrix(top: top, bottom: bottom, left: left, right: right, near: near, far: far)
//        print(matrix)
        return matrix
    }

    public var viewMatrix: float4x4 {
        let translationMatrix = float4x4(translation: transform.position)
        let rotationMatrix = float4x4(rotation: transform.rotation)

        return (translationMatrix * rotationMatrix).inverse
    }

    public func zoom(delta: Float) {
    }

    public func rotate(delta: float2) {
    }
}
