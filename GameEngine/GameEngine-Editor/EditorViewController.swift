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

    private lazy var editorView: NSView = {
        let width:CGFloat = 200
        let frame = NSRect(origin: CGPoint(x: initialFrame.width - width, y: 0), size: CGSize(width: width, height: initialFrame.height))
        let view = NSView(frame: frame)

        return view
    }()

    private lazy var label: NSTextField = {
        let height: CGFloat = 22
        let frame = CGRect(origin: CGPoint(x: 0, y: editorView.bounds.maxY - height), size: CGSize(width: editorView.bounds.width, height: height))
        let label = NSTextField(frame: frame)
        label.stringValue = "Object"
        label.backgroundColor = .clear
        label.isBezeled = false
        label.isEditable = false
        label.alignment = NSTextAlignment.center

        return label
    }()

    override func loadView() {
        view = NSView(frame: initialFrame)
        view.addSubview(editorSceneView)
        view.addSubview(editorView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        editorView.addSubview(label)
    }
}


extension EditorViewController: EditorGameViewDelegate {

    func selectedObject(name: String) {
        print("select " + name)
        label.stringValue = name
    }
}
