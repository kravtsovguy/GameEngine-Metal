//
//  EditorRenderable.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 25/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal
import GameEngine


protocol EditorRenderable: Renderable {

    var editorColor: EditorRendererPass.PixelColor { get }
    func renderEditor(commandEncoder: MTLRenderCommandEncoder)

}
