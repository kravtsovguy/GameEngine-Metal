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
        return view
    }()

    private lazy var editorView: NSView = {
        let frame = NSRect(origin: CGPoint(x: initialFrame.width - 200, y: 0), size: CGSize(width: 200, height: initialFrame.height))
        let view = NSView(frame: frame)

        return view
    }()

    private lazy var label: NSTextField = {
        let label = NSTextField()
        label.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        label.stringValue = "My awesome label"
        label.backgroundColor = .white
        label.isBezeled = false
        label.isEditable = false
        label.sizeToFit()

        return label
    }()

    override func loadView() {
        view = NSView(frame: initialFrame)
        view.addSubview(editorSceneView)
        view.addSubview(editorView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
