//
//  Transform.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import simd


/// Transform Component which contains calculated worldMatrix
public final class Transform: Component {
    
    public var position: float3 = [0, 0, 0]
    public var rotation: float3 = [0, 0, 0] {
        didSet {
            let rotationMatrix = float4x4(rotation: rotation)
            quaternion = simd_quatf(rotationMatrix)
        }
    }
    public var scale: float3 = [1, 1, 1]
    var quaternion: simd_quatf = simd_quatf()

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

    public var rightVector: float3 {
        return normalize(matrix.columns.0.xyz)
    }

    public var upVector: float3 {
        return normalize(matrix.columns.1.xyz)
    }

    public var forwardVector: float3 {
        return normalize(matrix.columns.2.xyz)
    }
}
