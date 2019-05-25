//
//  Scene.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


open class Scene: Liveable {
    
    public var name: String
    public private(set) var rootNode: Node = Node(with: "Root")
    public private(set) weak var cameraComponent: CameraComponent?
    public private(set) var renderables: [Renderable] = []

    required public init() {
        self.name = "Untitled"
    }

    public init(name: String) {
        self.name = name
    }

    public func add(node: Node) {
        rootNode.add(childNode: node)
    }

    open func start() {
        print("scene \(name)")
        rootNode.printStructure()

        cameraComponent = rootNode.findComponent()
        renderables = rootNode.renderables
        rootNode.start()
    }

    open func update(with deltaTime: Float) {
        rootNode.update(with: deltaTime)
    }
}
