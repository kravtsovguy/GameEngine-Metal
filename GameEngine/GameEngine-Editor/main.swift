//
//  main.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 18/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


Main.start { params in
    params.viewControllerType = EditorViewController.self
    params.viewType = EditorGameView.self
    params.sceneType = EditorScene.self
    params.title = "Editor"
}
