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

// Platform independent renderer class
class Renderer: NSObject, MTKViewDelegate {

    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer

    let vertexData: [Float] = [
        0.0,  1.0, 0.0,
        -1.0, -1.0, 0.0,
        1.0, -1.0, 0.0
    ]

    public init(metalKitView: MTKView) throws {
        // configure mtkvview
        metalKitView.colorPixelFormat = .bgra8Unorm_srgb
        metalKitView.preferredFramesPerSecond = 60

        // get device
        let device = metalKitView.device!

        // init command queue
        commandQueue = device.makeCommandQueue()!

        // init vertex buffer
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!

        // init pipeline
        let resourcePath = Bundle.main.path(forResource: "ShadersLibrary", ofType: "metallib")!
        let defaultLibrary = try! device.makeLibrary(URL: URL(fileURLWithPath: resourcePath))
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

        super.init()

        // assign delegate
        metalKitView.delegate = self
    }

    private func render(view: MTKView) {
        guard
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let drawable = view.currentDrawable,
            let commandBuffer = commandQueue.makeCommandBuffer()
            else { return }

        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)

        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func draw(in view: MTKView) {
        /// Per frame updates here
        autoreleasepool {
            render(view: view)
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        /// Respond to drawable size or orientation changes here
    }
}
