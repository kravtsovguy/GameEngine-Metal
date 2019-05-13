//
//  Node.swift
//  GameEngine macOS
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


public final class Node: Liveable {

    public var name: String
    public private(set) weak var parent: Node?
    public private(set) var children: [Node] = []
    public private(set) var components: [Component] = []
    public private(set) var transform: Transform
    var renderables: [Renderable] {

        var renderables: [Renderable] = []
        for component in components {
            if let renderable =  component as? Renderable {
                renderables.append(renderable)
            }
        }
        for child in children {
            renderables.append(contentsOf: child.renderables)
        }

        return renderables
    }

    public init(with name: String = "Untitled", setup:((Node)->Void)? = nil) {
        self.name = name
        self.transform = Transform()
        self.transform.node = self
        setup?(self)
    }

    public func add(childNode: Node) {
        childNode.parent?.remove(childNode: childNode)
        childNode.parent = self
        children.append(childNode)
    }

    public func remove(childNode: Node) {
        children.removeAll { $0 === childNode }
        childNode.parent = nil
    }

    public func add<T: Component>(component: T, setup:((T)->Void)? = nil) {
        component.node?.remove(component: component)
        component.node = self
        components.append(component)
        setup?(component)
    }

    public func remove(component: Component) {
        components.removeAll { $0 === component }
        component.node = nil
    }

    public func start() {
        for component in components {
            component.start()
        }

        for childNode in children {
            childNode.start()
        }
    }

    public func update(with deltaTime:Float) {
        for component in components {
            component.update(with: deltaTime)
        }

        for childNode in children {
            childNode.update(with: deltaTime)
        }
    }

    public func findComponent<T: Component>() -> T? {
        for component in components {
            guard let neededComponent = component as? T else { continue }
            return neededComponent
        }

        for childNode in children {
            guard let neededComponent: T = childNode.findComponent() else { continue }
            return neededComponent
        }

        return nil
    }

    func printStructure(depthLevel: Int = 0) {
        let nodeLevel = String(repeating: "\t", count: depthLevel)
        let componentLevel = String(repeating: "\t", count: depthLevel + 1)
        print("\(nodeLevel)node \(name)")

        for component in components {
            var componentType = "component"

            if let renderable = component as? Renderable {
                componentType = "renerable(\(renderable.name))"
            }

            print("\(componentLevel)\(componentType) \(String(describing:type(of: component)))")
        }

        for childNode in children {
            childNode.printStructure(depthLevel: depthLevel + 1)
        }
    }
}
