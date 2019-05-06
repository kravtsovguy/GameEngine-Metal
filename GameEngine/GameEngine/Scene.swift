//
//  Scene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

class Scene {
    var name: String = "Main"
    var rootNode: Node = Node()
    var renderables: [Renderable] = []
    var camera: Camera!

    init() {
        setupScene()
    }

    final func add(node: Node, parent: Node? = nil) {
        if let parent = parent {
            parent.add(childNode: node)
        } else {
            rootNode.add(childNode: node)
        }

        if let renderable = node as? Renderable {
            renderables.append(renderable)
        }
    }

    func setupScene() {
        // override this to add objects to the scene
    }

}
