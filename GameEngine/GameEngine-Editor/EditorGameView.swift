//
//  EditorGameView.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Cocoa
import GameEngine


protocol EditorGameViewDelegate: AnyObject {
    func selectedObject(name: String)
}


final class EditorGameView: GameView {
    private let renderPass: EditorRendererPass = EditorRendererPass()
    weak var editorDelegate: EditorGameViewDelegate?

    override func setup() {
        super.setup()
        renderer.renderPasses.append(renderPass)
    }

    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        guard let scene = scene else { return }

        let scale: UInt = UInt(self.currentDrawable!.layer.contentsScale)
        let size: (width: UInt, height: UInt) = (UInt(self.drawableSize.width), UInt(self.drawableSize.height))
        let position: (x: UInt, y: UInt) = (UInt(event.locationInWindow.x) * scale, size.height - UInt(event.locationInWindow.y) * scale)
        let pixel = renderPass.pixel(x: position.x, y: position.y)

        var selected: Renderable?

        if pixel != renderPass.backgoundColor {
            for renderable in scene.renderables {
                if
                    let editorRenderable = renderable as? EditorRenderable,
                    pixel == editorRenderable.editorColor {
                    selected = renderable
                }
            }
        }

        editorDelegate?.selectedObject(name: selected?.name ?? "none")
    }

}
