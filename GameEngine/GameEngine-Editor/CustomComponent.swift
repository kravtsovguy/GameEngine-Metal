//
//  CustomComponent.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 26/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


class CustomComponent: Component {

    var age: Parameter = Parameter<Int>(value: 1)
    var name: Parameter = Parameter<String>(value: "Adam")
    
}
