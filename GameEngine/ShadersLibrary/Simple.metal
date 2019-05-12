//
//  Simple.metal
//  GameEngine
//
//  Created by Matvey Kravtsov on 10/05/2019.
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
    float3 worldPosition;
    float3 worldNormal;
    float2 uv;
};



vertex VertexOut vertex_simple(VertexIn vertexBuffer [[stage_in]],
                             constant Uniforms &uniforms [[buffer(21)]]
                             ) {
    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexBuffer.position;
    out.worldNormal = (uniforms.modelMatrix * float4(vertexBuffer.normal, 0)).xyz;
    out.worldPosition = (uniforms.modelMatrix * vertexBuffer.position).xyz;
    out.uv = vertexBuffer.uv;
    return out;
}
