//
//  MainScene.swift
//  GameEngine-Demo
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


final class MainScene: Scene {
    
    let camera = Node(with: "Camera") { node in
        node.add(component: ArcballCamera()) { component in
            component.target = [0, 0.8, 0]
            component.distance = 4
            component.transform.rotation = [-0.4, -0.4, 0]
        }

//        node.add(component: CameraComponent(projectionType: .defaultOrthographic)) { component in
//            component.transform.position = [0, 0, -5]
//        }

//        node.add(component: FPSCameraComponent(projectionType: .defaultPerspective)) { component in
//            component.transform.position = [0, 0, -5]
//            component.transform.rotation = [0, 0, radians(fromDegrees: 0)]
//        }

        node.add(component: SoundComponent()) { component in
            component.playBackgroundMusic("ambient.wav")
        }
    }

    let train = Node(with: "Train") { node in
        let trainModel = Model(withObject: "train")
        node.add(component: ModelComponent(model: trainModel))
        node.add(component: ModeForwardComponent())
        node.transform.position.z = 0
        node.transform.scale = float3(repeating: 0.5)
        node.transform.rotation.y = radians(fromDegrees: 0)
    }

    let trees = Node(with: "Trees") { node in
        let treeModel = Model(withObject: "treefir")
        let treesComponent = InstanceComponent(model: treeModel, instanceCount: 3)
        node.add(component: treesComponent) { component in
            for i in 0..<3 {
                component.transforms[i].position.x = Float(i)
                component.transforms[i].position.y = 0
                component.transforms[i].position.z = 1
            }
        }
    }

    let plane = Node(with: "Plane") { node in
        let planeModel = Model.plane(material: Material(baseColor: [0.5,0.5,0.5],
                                                        specularColor: [0.5,0.5,0.5],
                                                        shininess: 1))
        node.add(component: ModelComponent(model: planeModel))
    }

    let sphere = Node(with: "Sphere") { node in
        let sphereModel = Model.sphere(material: Material(baseColor: [1.0,0.0,0.0],
                                                          specularColor: [0.2,0.2,0.2],
                                                          shininess: 1))
        node.add(component: ModelComponent(model: sphereModel))
        node.transform.position.y = 0.5
        node.transform.position.x = -1
        node.transform.scale = float3(repeating: 0.5)
    }

    required init() {
        super.init(name: "Main")
        add(node: camera)
        add(node: train)
        add(node: trees)
        add(node: plane)
        add(node: sphere)
    }
}
