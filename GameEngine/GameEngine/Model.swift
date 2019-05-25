//
//  Model.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 12/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


public class Model {

    private static let allocator = MTKMeshBufferAllocator(device: Metal.device)
    private static let vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor()
    public let name: String
    public let meshes: [Mesh]

    required init(name: String, meshes: [Mesh]) {
        self.name = name
        self.meshes = meshes
    }
    
    public convenience init(withObject name: String) {
        let assetURL = Bundle.main.url(forResource: name, withExtension: "obj")
        let asset = MDLAsset(url: assetURL,
                             vertexDescriptor: Model.vertexDescriptor,
                             bufferAllocator: Model.allocator)
        asset.loadTextures()

        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: Metal.device)
        let meshes = zip(mdlMeshes, mtkMeshes).map {
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }

        self.init(name: name, meshes: meshes)
    }

    public static func sphere(material: Material) -> Model {
        let mdlMesh = MDLMesh(sphereWithExtent: [1, 1, 1],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: .triangles,
                              allocator: allocator)

        mdlMesh.vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor()
        mdlMesh.submeshes?.forEach {
            if let submesh = $0 as? MDLSubmesh {
                submesh.material = MDLMaterial(material: material)
            }
        }

        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: Metal.device)
        let mesh = Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)

        return Model(name: "Sphere", meshes: [mesh])
    }

    public static func plane(material: Material) -> Model {
        let vertices: [Vertex] = [
            Vertex(position: [-0.5, 0,  0.5], normal: [0, 1, 0], uv: [0, 1]),
            Vertex(position: [-0.5, 0, -0.5], normal: [0, 1, 0], uv: [0, 0]),
            Vertex(position: [0.5 , 0,  0.5], normal: [0, 1, 0], uv: [1, 1]),
            Vertex(position: [0.5 , 0, -0.5], normal: [0, 1, 0], uv: [1, 0]),
        ]

        let indices: [UInt16] = [
            0, 1, 2,
            2, 1, 3,
        ]

        let vertexBuffer = allocator.newBuffer(MemoryLayout<Vertex>.stride * vertices.count, type: .vertex)
        let vertexMap = vertexBuffer.map()
        vertexMap.bytes.assumingMemoryBound(to: Vertex.self).assign(from: vertices, count: vertices.count)

        let indexBuffer = allocator.newBuffer(MemoryLayout<UInt16>.stride * indices.count, type: .index)
        let indexMap = indexBuffer.map()
        indexMap.bytes.assumingMemoryBound(to: UInt16.self).assign(from: indices, count: indices.count)

        let submesh = MDLSubmesh(indexBuffer: indexBuffer,
                                 indexCount: indices.count,
                                 indexType: .uint16,
                                 geometryType: .triangles,
                                 material: MDLMaterial(material: material))

        let mdlMesh = MDLMesh(vertexBuffer: vertexBuffer,
                              vertexCount: vertices.count,
                              descriptor: MDLVertexDescriptor.defaultVertexDescriptor(),
                              submeshes: [submesh])

        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: Metal.device)
        let mesh = Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)

        return Model(name: "Plane", meshes: [mesh])
    }
}
