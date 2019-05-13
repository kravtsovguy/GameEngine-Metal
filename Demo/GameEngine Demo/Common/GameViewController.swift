//
//  GameViewController.swift
//  GameEngine-Demo
//
//  Created by Matvey Kravtsov on 12/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


final class GameViewController: GameEngine.GameViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        scene = MainScene()
    }

}
