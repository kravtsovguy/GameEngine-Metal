//
//  FPSCameraComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


public class FPSCameraComponent: CameraComponent {
    let speed: Float = 2
    let sensitivity: Float = 0.5

    public override func update(with deltaTime: Float) {
        if Keyboard.isKeyPressed(.w) {
            self.transform.position += self.transform.forwardVector * speed * deltaTime
        }

        if Keyboard.isKeyPressed(.s) {
            self.transform.position -= self.transform.forwardVector * speed * deltaTime
        }

        if Keyboard.isKeyPressed(.d) {
            self.transform.position += self.transform.rightVector * speed * deltaTime
        }

        if Keyboard.isKeyPressed(.a) {
            self.transform.position -= self.transform.rightVector * speed * deltaTime
        }

        transform.rotation.y += Mouse.GetDX() * sensitivity * deltaTime
        transform.rotation.x += Mouse.GetDY() * sensitivity * deltaTime
    }
}
