//
//  Extensions.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 04/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


extension MTLVertexDescriptor {

    static func defaultVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()

        // position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0

        // normal
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0

        // uv
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride * 2
        vertexDescriptor.attributes[2].bufferIndex = 0

        // layout
        vertexDescriptor.layouts[0].stride = MemoryLayout<float3>.stride * 2 + MemoryLayout<float2>.stride

        return vertexDescriptor
    }
}


extension MDLVertexDescriptor {
    
    static func defaultVertexDescriptor() -> MDLVertexDescriptor {
        let vertexDescriptor = MTKModelIOVertexDescriptorFromMetal(.defaultVertexDescriptor())

        let attributePosition = vertexDescriptor.attributes[0] as! MDLVertexAttribute
        attributePosition.name = MDLVertexAttributePosition

        let attributeNormal = vertexDescriptor.attributes[1] as! MDLVertexAttribute
        attributeNormal.name = MDLVertexAttributeNormal

        let attributeUV = vertexDescriptor.attributes[2] as! MDLVertexAttribute
        attributeUV.name = MDLVertexAttributeTextureCoordinate

        return vertexDescriptor
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
