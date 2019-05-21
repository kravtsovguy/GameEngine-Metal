//
//  main.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 18/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


Main.start { params in
    params.viewControllerType = EditorViewController.self
    params.viewType = EditorView.self
    params.sceneType = EditorScene.self
}
