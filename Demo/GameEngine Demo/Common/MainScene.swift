//
//  MainScene.swift
//  GameEngine-Demo
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


public final class MainScene: Scene {
    let cameraNode = Node(with: "Camera")
    let train = Node(with: "Train")
    let trees = Node(with: "Trees")
    let plane = Node(with: "Plane")
    let sphere = Node(with: "Sphere")

    override public func setupScene() {
        let cameraComponent = OrthographicCamera()
//        cameraComponent.target = [0, 0.8, 0]
//        cameraComponent.distance = 4
        cameraNode.add(component: cameraComponent)
        cameraComponent.transform.position = [0, 0, -2]
//        cameraNode.transform.rotation = [-0.4, -0.4, 0]
        self.camera = cameraComponent

        let treeModel = Model(withObject: "treefir")
        let treesComponent = InstanceComponent(model: treeModel, instanceCount: 3)
        for i in 0..<3 {
            treesComponent.transforms[i].position.x = Float(i)
            treesComponent.transforms[i].position.y = 0
            treesComponent.transforms[i].position.z = 1
        }
        trees.add(component: treesComponent)

        let trainModel = Model(withObject: "train")
        train.add(component: ModelComponent(model: trainModel))
        train.add(component: ModeForwardComponent())
        train.transform.position.z = 0
        train.transform.scale = float3(repeating: 0.5)
        train.transform.rotation.y = radians(fromDegrees: 0)

        let planeModel = Model.plane(material: Material(baseColor: [0.5,0.5,0.5],
                                                        specularColor: [0.5,0.5,0.5],
                                                        shininess: 1))
        plane.add(component: ModelComponent(model: planeModel))

        let sphereModel = Model.sphere(material: Material(baseColor: [1.0,0.0,0.0],
                                                          specularColor: [0.2,0.2,0.2],
                                                          shininess: 1))
        sphere.add(component: ModelComponent(model: sphereModel))

        sphere.transform.position.y = 1
        
        add(node: cameraNode)
        add(node: train)
        add(node: trees)
        add(node: plane)
        add(node: sphere)
    }
}
