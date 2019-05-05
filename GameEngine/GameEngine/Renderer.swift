//
//  Renderer.swift
//  GameEngine Shared
//
//  Created by Matvey Kravtsov on 31/03/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal
import MetalKit
import simd

struct Vertex {
    let position: float3
    let color : float3
}

// Platform independent renderer class
class Renderer: NSObject {
    internal static var device: MTLDevice!
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let camera: Camera
    private var uniforms: Uniforms
    private var fragmentUniforms: FragmentUniforms
//    let vertexBuffer: MTLBuffer
//
//    let vertexData: [Float] = [
//        0.0,  1.0, 0.0,
//        -1.0, -1.0, 0.0,
//        1.0, -1.0, 0.0
//    ]

//    let positionArray = [
//        float3(-0.5, -0.2, 0),
//        float3(0.2, -0.2, 0),
//        float3(0, 0.5, 0),
//        float3(0.7, 0.7, 0),
//    ];
//
//    let colorArray = [
//        float3(1, 0, 0),
//        float3(0, 1, 0),
//        float3(0, 0, 1),
//        float3(1, 0, 0),
//    ];

//    let vertices = [
//        Vertex(position: float3(-0.5, -0.2, 0), color: float3(1, 0, 0)),
//        Vertex(position: float3(0.2, -0.2, 0),  color: float3(0, 1, 0)),
//        Vertex(position: float3(0, 0.5, 0),     color: float3(0, 0, 1)),
//        Vertex(position: float3(0.7, 0.7, 0),   color: float3(1, 0, 1)),
//    ]
//
//    let indexArray: [UInt16] = [
//        0, 1, 2,
//        2, 1, 3,
//    ]

//    let positionBuffer: MTLBuffer
//    let colorBuffer: MTLBuffer
//    let indexBuffer: MTLBuffer
//    let vertexBuffer: MTLBuffer
//    var timer: Float = 0

    let train: Model

    required init(view: MTKView) {
        // init command queue and device
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
                fatalError("Unable to connect to GPU")
        }

        guard
            let resourcePath = Bundle.main.path(forResource: "ShadersLibrary", ofType: "metallib"),
            let defaultLibrary = try? device.makeLibrary(URL: URL(fileURLWithPath: resourcePath)) else {
                fatalError("Unable to load shaders library")
        }

        Renderer.device = device
        self.commandQueue = commandQueue
        self.pipelineState = Renderer.createRenderPipeline(with: defaultLibrary, view: view)
        self.depthStencilState = Renderer.createDepthState()
        // init vertex buffer
//        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
//        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
//        positionBuffer = device.makeBuffer(bytes: positionArray ,
//                                           length: positionArray.count * MemoryLayout<float3>.stride,
//                                           options: [])!
//
//        colorBuffer = device.makeBuffer(bytes: colorArray,
//                                        length: colorArray.count * MemoryLayout<float3>.stride,
//                                        options: [])!

//        vertexBuffer = device.makeBuffer(bytes: vertices,
//                                         length: vertices.count * MemoryLayout<Vertex>.stride,
//                                         options: [])!
//
//        indexBuffer = device.makeBuffer(bytes: indexArray,
//                                        length: indexArray.count * MemoryLayout<UInt16>.stride,
//                                        options: [])!

        // init pipeline


        train = Model(name: "train")
//        train.transform.position.y = -0.5
        train.transform.position.z = 0
        train.transform.scale = float3(repeating: 0.5)
//        train.transform.rotation.z = radians(fromDegrees: 45)

        camera = Camera()
        camera.transform.position = [0, 0.5, -1.5]

        uniforms = Uniforms()
        fragmentUniforms = FragmentUniforms()

        super.init()
    }

    static func createRenderPipeline(with library: MTLLibrary, view: MTKView) -> MTLRenderPipelineState {
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat
        pipelineStateDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
        pipelineStateDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
        pipelineStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()

        return try! Renderer.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }

    static func createDepthState() -> MTLDepthStencilState {
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true

        return Renderer.device.makeDepthStencilState(descriptor: depthDescriptor)!
    }
}


extension Renderer: MTKViewDelegate {

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        /// Respond to drawable size or orientation changes here
        camera.aspect = Float(view.bounds.width / view.bounds.height)
    }

    func draw(in view: MTKView) {
        /// Per frame updates here
        guard
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
            let drawable = view.currentDrawable
            else { return }
        

        /*{
//        timer += 0.05
//        var translate = sin(timer)

//        commandEncoder.setVertexBuffer(positionBuffer, offset: 0, index: 0)
//        commandEncoder.setVertexBuffer(colorBuffer, offset: 0, index: 1)
//        commandEncoder.setVertexBytes(&translate, length: MemoryLayout<Float>.stride, index: 2)
//        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0) 
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indexArray.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)

        }*/

        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setDepthStencilState(depthStencilState)

        uniforms.viewMatrix = camera.viewMatrix
        uniforms.projectionMatrix = camera.projectionMatrix
        uniforms.modelMatrix = train.transform.matrix

        commandEncoder.setFragmentBytes(&fragmentUniforms,
                                        length: MemoryLayout<FragmentUniforms>.stride,
                                        index: 21);

//        let viewTransform = Transform()
//        viewTransform.position.y = 1.0
//
//        let projectionMatrix = float4x4(projectionFov: 70,
//                                        near: 0.1,
//                                        far: 100,
//                                        aspect: Float(view.bounds.width / view.bounds.height))
//
//        var viewMatrix = projectionMatrix * viewTransform.matrix.inverse
//        commandEncoder.setVertexBytes(&viewMatrix,
//                                      length: MemoryLayout<float4x4>.stride,
//                                      index: 22)
//
        commandEncoder.setVertexBytes(&uniforms,
                                      length: MemoryLayout<Uniforms>.stride,
                                      index: 21)

        for mtkMesh in train.mtkMeshes {
            for vertexBuffer in mtkMesh.vertexBuffers {

                commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                               offset: vertexBuffer.offset,
                                               index: 0)

                var colorID: UInt = 0

                for submesh in mtkMesh.submeshes {
                    commandEncoder.setVertexBytes(&colorID,
                                                  length: MemoryLayout<uint>.stride,
                                                  index: 20)
                    commandEncoder.drawIndexedPrimitives(type: .triangle,
                                                         indexCount: submesh.indexCount,
                                                         indexType: submesh.indexType,
                                                         indexBuffer: submesh.indexBuffer.buffer,
                                                         indexBufferOffset: submesh.indexBuffer.offset)

                    colorID+=1
                }
            }
        }


        commandEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

}
