//
//  main.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 18/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine

//let c = CustomComponent()
let b = {
//    let mirror = Mirror.init(reflecting: c)
//
//    for (label, value) in mirror.children {
//        guard let label = label else { continue }
//
//        print("\(label): \(value)")
//
//        if let param = value as? Component.Parameter<Int> {
//            param.value = 2
//        }

//        switch type(of: value) {
//            case Component.Parameter<Int>:
//                break
//        }

//        if value is Component.Parameter<Int> {
//
//        }

//        if let param = value as? Component.Parameter<Int> {
////            print(param.value)
//////            print(param.self)
//////            print(param.self.ParameterType)
//            let t = type(of: param)
//            print(t.ParameterType.self)
//            print(String(describing:type(of: param.self).self))
//        }


    }

b()
//c.set(key: "param", value: 2)
//b()

Main.start { params in
    params.viewControllerType = EditorViewController.self
    params.viewType = EditorGameView.self
    params.sceneType = EditorScene.self
    params.title = "Editor"
}
