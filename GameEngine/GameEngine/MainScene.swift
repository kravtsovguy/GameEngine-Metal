//
//  MainScene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

class MainScene: Scene {
    let train = Model(name: "train")
    let trees = Instance(name: "treefir", instanceCount: 3)

    override func setupScene() {
        camera = Camera()
        camera.transform.position = [0, 1.5, -3]
        
        train.transform.position.z = 0
        train.transform.scale = float3(repeating: 0.5)

        for i in 0..<3 {
            trees.transforms[i].position.x = Float(i)
            trees.transforms[i].position.y = 0
            trees.transforms[i].position.z = 1
        }

        add(node: camera)
        add(node: train)
        add(node: trees)
    }
}
