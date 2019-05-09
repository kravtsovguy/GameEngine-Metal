//
//  ModeForwardComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

open class ModeForwardComponent: Component {

    override func start() {
    }

    override func update(with deltaTime: Float) {
        self.transform.position += self.transform.rightVector * deltaTime
    }
}
