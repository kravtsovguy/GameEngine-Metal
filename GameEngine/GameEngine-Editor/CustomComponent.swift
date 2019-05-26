//
//  CustomComponent.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 26/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


class CustomComponent: Component {
//    var parameters

//    override var properties: [String] {
//        return [ "param" ]
//    }
//
//    override func set(key: String, value: Any) {
//        switch key {
//        case "param":
//            param = value as! Int
//        default:
//            return
//        }
//
//        let parameter = Parameter(key: "param", value: 1)
//        let type = parameter.type
//        if (type == Int.self) {
//            print("Int")
//        }
//    }

//    var param: Int = 1

    var age: Parameter = Parameter<Int>(value: 1)
    var name: Parameter = Parameter<String>(value: "Adam")

}
