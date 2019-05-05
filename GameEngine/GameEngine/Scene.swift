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


    final func add(node: Node, parent: Node? = nil, render: Bool = true) {
        if let parent = parent {
            parent.add(childNode: node)
        } else {
            rootNode.add(childNode: node)
        }

        if render, let renderable = node as? Renderable {
            renderables.append(renderable)
        }
    }

    func setupScene() {
        // override this to add objects to the scene
    }

}
