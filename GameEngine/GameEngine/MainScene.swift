//
//  MainScene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

open class MainScene: Scene {
    let train = Model(name: "train")
    let trees = Instance(name: "treefir", instanceCount: 3)

    override func setupScene() {
        let camera = ArcballCamera(with: "Camera")
        camera.target = [0, 0.8, 0]
        camera.distance = 4
        camera.transform.rotation = [-0.4, -0.4, 0]
        self.camera = camera

        train.transform.position.z = 0
        train.transform.scale = float3(repeating: 0.5)
        train.transform.rotation.y = radians(fromDegrees: 0)

        for i in 0..<3 {
            trees.transforms[i].position.x = Float(i)
            trees.transforms[i].position.y = 0
            trees.transforms[i].position.z = 1
        }

        train.add(component: ModeForwardComponent())

        add(node: camera)
        add(node: train)
        add(node: trees)
    }
}
