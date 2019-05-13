//
//  CameraComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 05/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import simd


open class CameraComponent: Component {

    public enum ProjectionType {
        public static let defaultPerspective = ProjectionType.perspective(fov: radians(fromDegrees: 70))
        public static let defaultOrthographic = ProjectionType.orthographic(size: 5)

        case perspective(fov: Float)
        case orthographic(size: Float)
    }

    public var near: Float = 0.1 {
        didSet {
            projectionMatrix = calculateProjectionMatrix()
        }
    }

    public var far: Float = 100 {
        didSet {
            projectionMatrix = calculateProjectionMatrix()
        }
    }

    public var aspect: Float = 1 {
        didSet {
            projectionMatrix = calculateProjectionMatrix()
        }
    }

    public var projectionType: ProjectionType {
        didSet {
            projectionMatrix = calculateProjectionMatrix()
        }
    }
    public private(set) var projectionMatrix: float4x4 = float4x4.identity

    public init(projectionType: ProjectionType = .defaultPerspective) {
        self.projectionType = projectionType
        super.init()
    }

    public var viewMatrix: float4x4 {
        let translationMatrix = float4x4(translation: transform.position)
        let rotationMatrix = float4x4(rotationZYX: transform.rotation)

        return (translationMatrix * rotationMatrix).inverse
    }

    func calculateProjectionMatrix() -> float4x4 {
        switch projectionType {
        case .perspective(let fov):
            return float4x4.perspectiveMatrix(fov: fov,
                                              near: near,
                                              far: far,
                                              aspect: aspect)
        case .orthographic(let size):
            let left = -aspect * size
            let right = aspect * size
            let top = size
            let bottom = -size
            return float4x4.orthographicMatrix(top: top,
                                               bottom: bottom,
                                               left: left,
                                               right: right,
                                               near: near,
                                               far: far)
        }
    }
}
