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
                                                        specularColor: [0.5,0.5,0.5],
                                                        shininess: 1))
        node.add(component: ModelComponent(model: planeModel))
    }

    required init() {
        super.init(name: "Editor")
        add(node: camera)
        add(node: plane)
    }
}
