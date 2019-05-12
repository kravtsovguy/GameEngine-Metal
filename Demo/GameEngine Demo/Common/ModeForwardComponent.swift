//
//  ModeForwardComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


public final class ModeForwardComponent: Component {

    override public func update(with deltaTime: Float) {
        self.transform.position += self.transform.rightVector * deltaTime
    }
}
