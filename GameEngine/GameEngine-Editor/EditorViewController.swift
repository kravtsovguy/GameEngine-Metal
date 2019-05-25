//
//  EditorViewController.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Cocoa
import GameEngine


final class EditorViewController: GameViewController {

    override var gameView: GameView {
        return editorSceneView
    }

    private lazy var editorSceneView: EditorGameView = {
        let frame = NSRect(origin: .zero, size: CGSize(width: initialFrame.width - 200, height: initialFrame.height))
        let view = EditorGameView(frame: frame)
        view.editorDelegate = self

        return view
    }()

    private lazy var editorView: EditorView = {
        let width:CGFloat = 200
        let frame = NSRect(origin: CGPoint(x: initialFrame.width - width, y: 0), size: CGSize(width: width, height: initialFrame.height))
        let view = EditorView(frame: frame)

        return view
    }()

    override func loadView() {
        view = NSView(frame: initialFrame)
        view.addSubview(editorSceneView)
        view.addSubview(editorView)
    }

}


extension EditorViewController: EditorGameViewDelegate {

    func selected(node: Node?) {
        print("select " + (node?.name ?? "none"))
        editorView.configure(with: EditorViewModel(node: node))
    }
}
