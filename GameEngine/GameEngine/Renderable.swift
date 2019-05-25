//
//  Renderable.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


public protocol Renderable: AnyObject {
    var id: UInt { get }
    var name: String { get }
    var node: Node! { get }
    func render(commandEncoder: MTLRenderCommandEncoder)
}
