//
//  EditorScene.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 18/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


final class EditorScene: Scene {

    let camera = Node(with: "Camera") { node in
        node.add(component: ArcballCamera()) { component in
            component.target = [0, 0.8, 0]
            component.distance = 4
            component.transform.rotation = [-0.4, -0.4, 0]
        }
    }

    let plane = Node(with: "Plane") { node in
        let planeModel = Model.plane(material: Material(baseColor: [0.5,0.5,0.5],
                                                        specularColor: [0.2,0.2,0.2],
                                                        shininess: 1))
        node.add(component: ModelComponent(model: planeModel))
        node.transform.scale = [3, 1, 3]
    }

    let sphere = Node(with: "Sphere") { node in
        let sphereModel = Model.sphere(material: Material(baseColor: [1.0,0.0,0.0],
                                                          specularColor: [0.2,0.2,0.2],
                                                          shininess: 1))
        node.add(component: ModelComponent(model: sphereModel))
        node.transform.position.y = 0.5
//        node.transform.position.x = -1
        node.transform.scale = float3(repeating: 0.5)
    }

    required init() {
        super.init(name: "Editor")
        add(node: camera)
        add(node: plane)
        add(node: sphere)
    }
}
