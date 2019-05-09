//
//  Node.swift
//  GameEngine macOS
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

open class Node: Liveable {
    var name: String
    private(set) weak var parent: Node?
    private(set) var children: [Node] = []
    private(set) var components: [Component] = []
    private(set) var transform: Transform!

    public init(with name: String = "Untitled") {
        self.name = name
        self.transform = Transform()
        add(component: transform)
    }

    func add(childNode: Node) {
        childNode.parent?.remove(childNode: childNode)
        childNode.parent = self
        children.append(childNode)
    }

    func remove(childNode: Node) {
        children.removeAll { $0 === childNode }
        childNode.parent = nil
    }

    func add(component: Component) {
        component.node?.remove(component: component)
        component.node = self
        components.append(component)
    }

    func remove(component: Component) {
        components.removeAll { $0 === component }
        component.node = nil
    }

    func start() {
        print("start \t node \(name)")

        for component in components {
            print("start \t\t component \(String(describing:type(of: component)))")
            component.start()
        }

        for childNode in children {
            childNode.start()
        }
    }

    func update(with deltaTime:Float) {
        for component in components {
            component.update(with: deltaTime)
        }

        for childNode in children {
            childNode.update(with: deltaTime)
        }
    }
}
