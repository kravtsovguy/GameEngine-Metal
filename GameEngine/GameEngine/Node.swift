//
//  Node.swift
//  GameEngine macOS
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation

open class Node {
    var name: String = "Untitled"
    var transform: Transform = Transform()

    weak var parent: Node?
    var children: [Node] = []

    var worldMatrix: float4x4 {
        if let parent = parent {
            return parent.worldMatrix * transform.matrix
        }
        return transform.matrix
    }

    final func add(childNode: Node) {
        children.append(childNode)
        childNode.parent = self
    }

//    final func remove(childNode: Node) {
//        for child in childNode.children {
//            child.parent = self
//            children.append(child)
//        }
//        childNode.children = []
//        guard let index = (children.firstIndex {
//            $0 === childNode
//        }) else { return }
//        children.remove(at: index)
//    }

//    var worldMatrix: float4x4 {
//        if let parent = parent {
//            return parent.worldMatrix * transform.matrix
//        }
//    }
}
