//
//  EditorView.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


class EditorView: GameView {

    override func setup() {
        super.setup()
        renderer.renderPasses.append(EditorRendererPass())
    }

}
