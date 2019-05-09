//
//  Component.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

open class Component: Liveable {

    weak var node: Node!

    var transform: Transform! {
        return node.transform
    }

    func start() {
        // override
    }

    func update(with deltaTime: Float) {
        // override
    }
}
