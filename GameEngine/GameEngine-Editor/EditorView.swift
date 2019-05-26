//
//  EditorView.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 26/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Cocoa


final class EditorView: NSView {

    private lazy var label: NSTextField = {
        let height: CGFloat = 22
        let frame = CGRect(origin: CGPoint(x: 0, y: self.bounds.maxY - height), size: CGSize(width: self.bounds.width, height: height))
        let label = NSTextField(frame: frame)
//        label.stringValue = "Object"
        label.backgroundColor = .clear
        label.isBezeled = false
        label.isEditable = false
        label.alignment = NSTextAlignment.center

        return label
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        addSubview(label)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: EditorViewModel?) {
        guard let viewModel = viewModel else {
            label.stringValue = ""
            return
        }

        label.stringValue = viewModel.name
    }
}
