//
//  SphereModelComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 11/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal

open class SphereModelComponent: Component {
    var name: String
    var material: Material
    let pipelineState: MTLRenderPipelineState
    let buffer: MTLBuffer
    let color: float3 = [0.5, 0.5, 0.5]
    let points: [Vertex]

    public init(with name: String) {
        self.name = name
        self.pipelineState = Renderer.createSimpleRenderPipeline()!
        self.material = Material(baseColor: color, specularColor: color, shininess: 1)
        self.points = SphereModelComponent.calculatePoints()
        self.buffer = Renderer.device.makeBuffer(bytes: points, length: points.count * MemoryLayout<Vertex>.stride, options: [])!
        super.init()
    }

    static func calculatePoints() -> [Vertex] {
        return []
    }
}
