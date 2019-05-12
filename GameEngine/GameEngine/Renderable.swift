//
//  Renderable.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation
import MetalKit

protocol Renderable {
    var name: String { get }
    var transform: Transform { get }
    func render(commandEncoder: MTLRenderCommandEncoder)
}
