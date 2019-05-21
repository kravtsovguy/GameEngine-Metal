////
////  EditorRenderer.swift
////  GameEngine
////
////  Created by Matvey Kravtsov on 21/05/2019.
////  Copyright © 2019 Matvey Kravtsov. All rights reserved.
////
//
//import MetalKit
//
//class EditorRenderer: Renderer {
//
//    private let editorPipeline = createEditorRenderPipeline()
//    private let editorRenderPassDescriptor = MTLRenderPassDescriptor()
//    private var editorTexture: MTLTexture!
//
//    override init() {
//        super.init()
//        renderPassDescriptors.append(editorRenderPassDescriptor)
//    }
//
//    static func createEditorRenderPipeline() -> MTLRenderPipelineState {
//        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
//        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm //view.colorPixelFormat
//        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float //view.depthStencilPixelFormat
//        pipelineStateDescriptor.vertexFunction =  Metal.library.makeFunction(name: "vertex_editor")
//        pipelineStateDescriptor.fragmentFunction = Metal.library.makeFunction(name: "fragment_editor")
//        pipelineStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()
//
//        return try! Metal.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
//    }
//
//    func buildTexture(pixelFormat: MTLPixelFormat, size: CGSize, label: String) -> MTLTexture {
//        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
//            pixelFormat: pixelFormat,
//            width: Int(size.width),
//            height: Int(size.height),
//            mipmapped: false)
//        descriptor.usage = [.renderTarget, .pixelFormatView]
//        descriptor.storageMode = .managed
//        guard let texture = Metal.device.makeTexture(descriptor: descriptor) else {
//            fatalError()
//        }
//        texture.label = "\(label) texture"
//        return texture
//    }
//
//    func buildEditorTexture(_ view: MTKView, size: CGSize) {
//        editorTexture = buildTexture(pixelFormat: .bgra8Unorm, size: size, label: "Editor")
//        editorRenderPassDescriptor.colorAttachments[0].texture = editorTexture
//        editorRenderPassDescriptor.colorAttachments[0].loadAction = .clear
//        editorRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
//        editorRenderPassDescriptor.depthAttachment = view.currentRenderPassDescriptor!.depthAttachment
//    }
//
//    struct Pixel {
//        let red: UInt8
//        let green: UInt8
//        let blue: UInt8
//        let alpha: UInt8
//    }
//
//    func readTexture(texture: MTLTexture) -> (data:UnsafeMutablePointer<Pixel>, width: Int, height: Int)  {
//        let width = texture.width
//        let height = texture.height
//        let sourceRowBytes = width * MemoryLayout<Pixel>.size
//        let floatValues = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
//
//        texture.getBytes(floatValues,
//                         bytesPerRow: sourceRowBytes,
//                         from: MTLRegionMake2D(0, 0, width, height),
//                         mipmapLevel: 0)
//
//        return (data: floatValues, width, height)
//    }
//
////    func renderEditorPass(scene: Scene, encoder: MTLRenderCommandEncoder) {
////        encoder.setDepthStencilState(depthStencilState)
////        encoder.setRenderPipelineState(editorPipeline)
////
////        for renderable in scene.renderables {
////            encoder.pushDebugGroup(renderable.name)
////
////            uniforms.modelMatrix = renderable.transform.worldMatrix
////            encoder.setVertexBytes(&uniforms,
////                                   length: MemoryLayout<Uniforms>.stride,
////                                   index: 21)
////
////            renderable.renderEditor(commandEncoder: encoder)
////            encoder.popDebugGroup()
////        }
////
////        encoder.endEncoding()
////    }
//
//    override func commandBufferCompleted(commandBuffer: MTLCommandBuffer) {
//        super.commandBufferCompleted(commandBuffer: commandBuffer)
//        _ = readTexture(texture: editorTexture)
//    }
//
//    override func render(renderable: Renderable, commandEncoder: MTLRenderCommandEncoder, renderPassDescriptor: MTLRenderPassDescriptor) {
//        guard renderPassDescriptor == editorRenderPassDescriptor else {
//            super.render(renderable: renderable, commandEncoder: commandEncoder, renderPassDescriptor: renderPassDescriptor)
//            return
//        }
//
//        renderable.renderEditor(commandEncoder: commandEncoder)
//    }
//
//    override func setup(commandBuffer: MTLCommandBuffer, renderPassDescriptor: MTLRenderPassDescriptor) {
//        guard renderPassDescriptor == editorRenderPassDescriptor else {
//            super.setup(commandBuffer: commandBuffer, renderPassDescriptor: renderPassDescriptor)
//            return
//        }
//
//        if let blitEncoder = commandBuffer.makeBlitCommandEncoder() {
//            blitEncoder.synchronize(texture: editorTexture, slice: 0, level: 0)
//            blitEncoder.endEncoding()
//        }
//    }
//
//    override func setup(encoder: MTLRenderCommandEncoder, renderPassDescriptor: MTLRenderPassDescriptor) {
//        guard renderPassDescriptor == editorRenderPassDescriptor else {
//            super.setup(encoder: encoder, renderPassDescriptor: renderPassDescriptor)
//            return
//        }
//
//        encoder.setDepthStencilState(depthStencilState)
//        encoder.setRenderPipelineState(editorPipeline)
//    }
//
//    override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
//        super.mtkView(view, drawableSizeWillChange: size)
//        buildEditorTexture(view, size: size)
//    }
//}
