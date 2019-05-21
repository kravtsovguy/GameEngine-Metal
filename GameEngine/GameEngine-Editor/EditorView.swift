//
//  EditorView.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Cocoa


class EditorView: GameView {
    let renderPass: EditorRendererPass = EditorRendererPass()

    override func setup() {
        super.setup()
        renderer.renderPasses.append(renderPass)
    }

    open override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let scale: uint = UInt32(self.currentDrawable!.layer.contentsScale)
        let size: uint2 = [UInt32(self.drawableSize.width), UInt32(self.drawableSize.height)]
        let position: uint2 = [UInt32(event.locationInWindow.x) * scale, size.y - UInt32(event.locationInWindow.y) * scale]
        let index = Int(position.y * size.x + position.x)
        let pixel = renderPass.pixelsPointer![index]

        var selected: Renderable?
        for renderable in scene?.renderables ?? [] {
            if pixel == renderable.editorColor {
                selected = renderable
            }
        }

        print("select \(selected?.name ?? "none")")
    }

}
