//
//  EditorRendererPass.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal
import MetalKit.MTKView
import GameEngine


class EditorRendererPass: RendererPassProtocol {

    struct PixelColor: Equatable {
        let blue: UInt8
        let green: UInt8
        let red: UInt8
        let alpha: UInt8

        var mtlColor: MTLClearColor {
            return MTLClearColor(red: Double(red) / Double(UInt8.max),
                                 green: Double(green) / Double(UInt8.max),
                                 blue: Double(blue) / Double(UInt8.max),
                                 alpha: Double(alpha) / Double(UInt8.max))
        }

        var float3: float3 {
            return [Float(red) / Float(UInt8.max),
                    Float(green) / Float(UInt8.max),
                    Float(blue) / Float(UInt8.max)]
        }

        static func ==(lhs: PixelColor, rhs: PixelColor) -> Bool {
            return lhs.red == rhs.red
                && lhs.green == rhs.green
                && lhs.blue == rhs.blue
                && lhs.alpha == rhs.alpha
        }
    }

    private var pixelsPointer: UnsafeMutablePointer<PixelColor>!
    private var editorTexture: MTLTexture!
    private let editorPipeline = createEditorRenderPipeline()

    let backgoundColor: PixelColor = PixelColor(blue: 0, green: 0, red: 0, alpha: 255)
    let renderPassDescriptor = MTLRenderPassDescriptor()

    func pixel(x: UInt, y: UInt) -> PixelColor {
        let index = Int(y * UInt(editorTexture.width) + x)

        return pixelsPointer[index]
    }

    static func createEditorRenderPipeline() -> MTLRenderPipelineState {
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm //view.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float //view.depthStencilPixelFormat
        pipelineStateDescriptor.vertexFunction =  Metal.developerLibrary.makeFunction(name: "vertex_editor")
        pipelineStateDescriptor.fragmentFunction = Metal.developerLibrary.makeFunction(name: "fragment_editor")
        pipelineStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()

        return try! Metal.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }

    func buildTexture(pixelFormat: MTLPixelFormat, size: CGSize, label: String) -> MTLTexture {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: pixelFormat,
            width: Int(size.width),
            height: Int(size.height),
            mipmapped: false)
        descriptor.usage = [.renderTarget, .pixelFormatView]
        descriptor.storageMode = .managed
        guard let texture = Metal.device.makeTexture(descriptor: descriptor) else {
            fatalError()
        }
        texture.label = "\(label) texture"
        return texture
    }

    func buildEditorTexture(depthAttachment: MTLRenderPassDepthAttachmentDescriptor, size: CGSize) {
        editorTexture = buildTexture(pixelFormat: .bgra8Unorm, size: size, label: "Editor")
        renderPassDescriptor.colorAttachments[0].texture = editorTexture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = backgoundColor.mtlColor
        renderPassDescriptor.depthAttachment = depthAttachment
    }

    func readTexture(texture: MTLTexture) {
        pixelsPointer?.deallocate()
        let width = texture.width
        let height = texture.height
        let sourceRowBytes = width * MemoryLayout<PixelColor>.size
        let pixelValues = UnsafeMutablePointer<PixelColor>.allocate(capacity: width * height)

        texture.getBytes(pixelValues,
                         bytesPerRow: sourceRowBytes,
                         from: MTLRegionMake2D(0, 0, width, height),
                         mipmapLevel: 0)

        pixelsPointer = pixelValues
    }

    func setup(commandBuffer: MTLCommandBuffer) {

    }

    func setup(commandEncoder: MTLRenderCommandEncoder, renderer: Renderer) {
        commandEncoder.setDepthStencilState(renderer.depthStencilState)
        commandEncoder.setRenderPipelineState(editorPipeline)
    }

    func render(commandEncoder: MTLRenderCommandEncoder, renderable: Renderable) {
        guard let editorRenderable = renderable as? EditorRenderable else { return }
        editorRenderable.renderEditor(commandEncoder: commandEncoder)
    }

    func teardown(commandBuffer: MTLCommandBuffer) {
        if let blitEncoder = commandBuffer.makeBlitCommandEncoder() {
            blitEncoder.synchronize(texture: editorTexture, slice: 0, level: 0)
            blitEncoder.endEncoding()
        }
    }

    func commandBufferCompleted(commandBuffer: MTLCommandBuffer) {
        readTexture(texture: editorTexture)
    }

    func updateWithView(view: MTKView) {
        buildEditorTexture(depthAttachment: view.currentRenderPassDescriptor!.depthAttachment, size: view.drawableSize)
    }
}
