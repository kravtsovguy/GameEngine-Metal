//
//  Component.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


open class Component: Liveable {

    public internal(set) weak var node: Node!
    public var transform: Transform { return node.transform }
    public init() { }

    open func start() {
        // override
    }

    open func update(with deltaTime: Float) {
        // override
    }
}
