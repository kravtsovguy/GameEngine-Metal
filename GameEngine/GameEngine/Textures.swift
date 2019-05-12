//
//  Textures.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 12/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import MetalKit


struct Textures {
    let baseColor: MTLTexture?

    init(material: MDLMaterial?) {
        guard let baseColor = material?.property(with: .baseColor), baseColor.type == .texture,
            let mdlTexture = baseColor.textureSamplerValue?.texture else {
                self.baseColor = nil
                return
        }

        let textureLoader = MTKTextureLoader(device: Metal.device)
        let textureLoaderOptions: [MTKTextureLoader.Option:Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft
        ]
        self.baseColor = try? textureLoader.newTexture(texture: mdlTexture,
                                                       options: textureLoaderOptions)
    }
}
