//
//  ArcballCameraComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


public class ArcballCamera: CameraComponent {
    
    public var distance: Float = 0
    public var target = float3(repeating: 0)
    public var sensitivity: Float = 0.5
    public var sensitivityWheel: Float = 1

    override public var viewMatrix: float4x4 {
        let translateMatrix = float4x4(translation: [target.x, target.y, target.z - distance])
        let rotateMatrix = float4x4(rotationZYX: [-transform.rotation.x,
                                                  transform.rotation.y,
                                                  0])

        let matrix = (rotateMatrix * translateMatrix).inverse
        transform.position = rotateMatrix.upperLeft * -matrix.columns.3.xyz
        return matrix
    }

    public override func update(with deltaTime: Float) {
        transform.rotation.y += Mouse.GetDX() * sensitivity * deltaTime
        transform.rotation.x -= Mouse.GetDY() * sensitivity * deltaTime
        transform.rotation.x = max(-Float.pi/2, min(transform.rotation.x, Float.pi/2))

        distance -= Mouse.GetDWheel() * sensitivityWheel * deltaTime
    }
}

