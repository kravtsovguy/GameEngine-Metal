//
//  MoveForwardComponent.swift
//  GameEngine-Demo
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


final class MoveForwardComponent: Component {

    override public func start() {
        print("MoveForwardComponent started")
    }

    override public func update(with deltaTime: Float) {
        self.transform.position += self.transform.rightVector * deltaTime
    }
}
