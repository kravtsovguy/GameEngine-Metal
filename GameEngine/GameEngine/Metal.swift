//
//  Metal.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 12/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import Metal


public enum Metal {
    public static let device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Unable to connect to GPU")
        }
        print("device: " + device.name)

        return device
    }()

    static let library: MTLLibrary = {
        guard
            let resourcePath = Bundle.main.path(forResource: "ShadersLibrary", ofType: "metallib"),
            let defaultLibrary = try? device.makeLibrary(URL: URL(fileURLWithPath: resourcePath)) else {
                fatalError("Unable to load shaders library")
        }
        return defaultLibrary
    }()

    public static let developerLibrary: MTLLibrary = {
        guard
            let defaultLibrary = device.makeDefaultLibrary() else {
                fatalError("Unable to load developer's shaders library")
        }
        return defaultLibrary
    }()

    static let commandQueue: MTLCommandQueue = {
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Unable to make command queue")
        }

        return commandQueue
    }()
}
