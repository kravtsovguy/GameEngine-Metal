//
//  EditorViewModel.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 26/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine


class EditorViewModel {
    var name: String

    init(node: Node?) {
        name = node?.name ?? ""
    }
}
