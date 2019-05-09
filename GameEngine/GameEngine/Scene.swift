//
//  Scene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

open class Scene: Liveable {
    
    public var name: String = "Main"
    public var rootNode: Node = Node(with: "Root")
    var renderables: [Renderable] = []
    var camera: Camera!

    public init() {
        setupScene()
    }

    final public func add(node: Node, parent: Node? = nil) {
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

    func start() {
        print("start scene \(name)")
        rootNode.start()
    }

    func update(with deltaTime: Float) {
        rootNode.update(with: deltaTime)
    }
}
