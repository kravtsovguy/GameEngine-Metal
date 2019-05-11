//
//  Scene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

open class Scene: Liveable {
    
    private(set) public var name: String = "Main"
    private(set) public var rootNode: Node = Node(with: "Root")
    private(set) var renderables: [Renderable] = []
    public internal(set) var camera: Camera!

    public init() {
        setupScene()
    }

    public func add(node: Node) {
        rootNode.add(childNode: node)
        renderables.append(contentsOf:node.renderables)
    }

    func setupScene() {
        // override this to add objects to the scene
    }

    func start() {
        print("scene \(name)")
        rootNode.printStructure()
        rootNode.start()
    }

    func update(with deltaTime: Float) {
        rootNode.update(with: deltaTime)
    }
}
