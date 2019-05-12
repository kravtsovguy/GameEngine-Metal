//
//  Transform.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation
import simd

public final class Transform: Component {
    var position: float3 = [0, 0, 0]
    var rotation: float3 = [0, 0, 0] {
        didSet {
            let rotationMatrix = float4x4(rotation: rotation)
            quaternion = simd_quatf(rotationMatrix)
        }
    }
    var scale: float3 = [1, 1, 1]
    var quaternion = simd_quatf()

    var matrix: float4x4 {
        let translationMatrix = float4x4(translation: position)
        let rotationMatrix = float4x4(quaternion)
        let scaleMatrix = float4x4(scaling: scale)

        return translationMatrix * rotationMatrix * scaleMatrix
    }

    var worldMatrix: float4x4 {
        if let parent = node.parent {
            return parent.transform.worldMatrix * matrix
        }
        return transform.matrix
    }

    var rightVector: float3 {
        return normalize(matrix.columns.0.xyz)
    }

    var upVector: float3 {
        return normalize(matrix.columns.1.xyz)
    }

    var forwardVector: float3 {
        return normalize(matrix.columns.2.xyz)
    }
}