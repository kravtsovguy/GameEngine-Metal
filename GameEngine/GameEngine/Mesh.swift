//
//  Mesh.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 06/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Foundation
import MetalKit

struct Mesh {
    let mtkMesh: MTKMesh
    let submeshes: [Submesh]

    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) {
        self.mtkMesh = mtkMesh
        submeshes = zip(mdlMesh.submeshes!, mtkMesh.submeshes).map {
            Submesh(mdlSubmesh: $0.0 as! MDLSubmesh, mtkSubmesh: $0.1)
        }
    }
}

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

struct Textures {
    let baseColor: MTLTexture?

    init(material: MDLMaterial?) {
        guard let baseColor = material?.property(with: .baseColor), baseColor.type == .texture,
            let mdlTexture = baseColor.textureSamplerValue?.texture else {
                self.baseColor = nil
                return
        }

        let textureLoader = MTKTextureLoader(device: Renderer.device)
        let textureLoaderOptions: [MTKTextureLoader.Option:Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft
        ]
        self.baseColor = try? textureLoader.newTexture(texture: mdlTexture,
                                                       options: textureLoaderOptions)
    }
}

extension Material {
    init(material: MDLMaterial?) {
        self.init()
        if let baseColor = material?.property(with: .baseColor), baseColor.type == .float3 {
            self.baseColor = baseColor.float3Value
        }

        if let specularColor = material?.property(with: .specular), specularColor.type == .float3 {
            self.specularColor = specularColor.float3Value
        }

        if let shininess = material?.property(with: .specularExponent), shininess.type == .float {
            self.shininess = shininess.floatValue
        }
    }
}

extension MDLMaterial {
    convenience init(material: Material) {
        self.init()

        let baseColorPropery = MDLMaterialProperty(name: "Base Color", semantic: .baseColor, float3: material.baseColor)
        setProperty(baseColorPropery)

        let specularColorPropery = MDLMaterialProperty(name: "Specular Color", semantic: .specular, float3: material.specularColor)
        setProperty(specularColorPropery)

        let shininessPropery = MDLMaterialProperty(name: "Shininess", semantic: .specularExponent, float: material.shininess)
        setProperty(shininessPropery)
    }
}
