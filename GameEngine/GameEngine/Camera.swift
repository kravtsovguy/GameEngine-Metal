//
//  Camera.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import simd
import MetalKit


public typealias CameraComponent = Camera & Component


public protocol Camera {
    var aspect: Float { get set }
    var near: Float { get set }
    var far: Float { get set }

    var viewMatrix: float4x4 { get }
    var projectionMatrix: float4x4 { get }

    func zoom(delta: Float)
    func rotate(delta: float2)
}

//extension Camera where Self: Component {
//    public var viewMatrix: float4x4 {
//        let translationMatrix = float4x4(translation: transform.position)
//        let rotationMatrix = float4x4(rotation: transform.rotation)
//
//        return (translationMatrix * rotationMatrix).inverse
//    }
//}
