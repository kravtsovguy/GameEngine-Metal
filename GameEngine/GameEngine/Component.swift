//
//  Component.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


open class Component: Liveable {

    final public internal(set) weak var node: Node!
    final public var transform: Transform { return node.transform }
    public init() { }

//    open var properties: [String] {
//        return []
//    }
//
//    final func set(properties: [String: Any]) {
//        for (key, value) in properties {
//            set(key: key, value: value)
//        }
//    }

    public final class Parameter<T> {

//        associatedtype Item
//        let key: String

//        public typealias ParameterType = T.Type

        public var value: T
//        let type: T.Type

        public init(value: T) {
//            self.key = key
            self.value = value
        }
    }

//    open func set(key:String, value: Any) {
//
//    }

    open func start() {
        // override
    }

    open func update(with deltaTime: Float) {
        // override
    }
}
