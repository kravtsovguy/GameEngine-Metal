//
//  ShaderEditor.metal
//  ShadersLibrary macOS
//
//  Created by Matvey Kravtsov on 21/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

#include <metal_stdlib>
#include "../GameEngine/ShaderTypes.h"

using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
    float2 uv [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_editor(VertexIn vertexBuffer [[stage_in]],
                             constant Uniforms &uniforms [[buffer(21)]]
                             ) {
    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexBuffer.position;
    return out;
}

fragment float4 fragment_editor(VertexOut in [[stage_in]],
                              constant float3 &color [[buffer(12)]]) {
    return float4(color, 1);
}
