//
//  Submesh.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 12/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


struct Submesh {
    let mtkSubmesh: MTKSubmesh
    let material: Material
    let textures: Textures
    let pipelineState: MTLRenderPipelineState
    let instancedPipelineState: MTLRenderPipelineState

    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
        self.mtkSubmesh = mtkSubmesh
        self.material = Material(material: mdlSubmesh.material)
        self.textures = Textures(material: mdlSubmesh.material)
        self.pipelineState = Renderer.createRenderPipeline(vertexFunctionName: "vertex_main", textures: textures)
        self.instancedPipelineState = Renderer.createRenderPipeline(vertexFunctionName: "vertex_instances", textures: textures)
    }
}
