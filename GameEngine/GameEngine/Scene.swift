//
//  Scene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


open class Scene: Liveable {
    
    public private(set) var name: String = "Main"
    public private(set) var rootNode: Node = Node(with: "Root")
    public var camera: Camera!
    private(set) var renderables: [Renderable] = []

    public init() {
        setupScene()
    }

    public func add(node: Node) {
        rootNode.add(childNode: node)
    }

    open func setupScene() {
        // override this to add objects to the scene
    }

    open func start() {
        print("scene \(name)")
        rootNode.printStructure()
        rootNode.start()

        renderables = rootNode.renderables
    }

    open func update(with deltaTime: Float) {
        rootNode.update(with: deltaTime)
    }
}
