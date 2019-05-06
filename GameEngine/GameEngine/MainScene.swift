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
    let tree = Model(name: "treefir")

    override func setupScene() {
        camera = Camera()
        camera.transform.position = [0, 0.5, -1.5]
        
        train.transform.position.z = 0
        train.transform.scale = float3(repeating: 0.5)

        tree.transform.position.z = 1
        tree.transform.position.x = -1
        tree.transform.scale = float3(repeating: 0.5)

        add(node: camera)
        add(node: train)
        add(node: tree)
    }
}
