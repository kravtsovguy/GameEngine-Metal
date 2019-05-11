//
//  MainScene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

public final class MainScene: Scene {
    let train = Node(with: "Train")
    let trees = Node(with: "Trees")
    let plane = Node(with: "Plane")

    override func setupScene() {
        let camera = Node(with: "Camera")
        let cameraComponent = ArcballCamera()
        cameraComponent.target = [0, 0.8, 0]
        cameraComponent.distance = 4
        camera.add(component: cameraComponent)
        camera.transform.rotation = [-0.4, -0.4, 0]
        self.camera = cameraComponent

        let treesComponent = Instance(name: "treefir", instanceCount: 3)
        for i in 0..<3 {
            treesComponent.transforms[i].position.x = Float(i)
            treesComponent.transforms[i].position.y = 0
            treesComponent.transforms[i].position.z = 1
        }
        trees.add(component: treesComponent)


        train.add(component: Model(name: "train"))
        train.add(component: ModeForwardComponent())
        train.transform.position.z = 0
        train.transform.scale = float3(repeating: 0.5)
        train.transform.rotation.y = radians(fromDegrees: 0)

        plane.add(component: PlaneModelComponent(with: plane.name))

        add(node: camera)
        add(node: train)
        add(node: trees)
        add(node: plane)
    }
}
