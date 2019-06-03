//
//  Component.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


open class Component: Liveable {

    public final class Parameter<T> {
        
        public var value: T {
            didSet {
                didSet?(value)
            }
        }

        public var didSet: ((T) -> ())?

        public init(value: T, didSet: ((T) -> ())? = nil) {
            self.value = value
            self.didSet = didSet
        }

    }

    final public internal(set) weak var node: Node!
    final public var transform: Transform { return node.transform }
    public init() { }

    open func start() {
        // override
    }

    open func update(with deltaTime: Float) {
        // override
    }
}
