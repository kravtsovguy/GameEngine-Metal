//
//  Shaders.metal
//  GameEngine Shared
//
//  Created by Matvey Kravtsov on 01/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

#include <metal_stdlib>
#include "../GameEngine/ShaderTypes.h"

using namespace metal;

constant float3 lightPosition = float3(2.0, 1.0, 0);
constant float3 ambientLightColor = float3(1.0, 1.0, 1.0);
constant float ambientLightIntensity = 0.4;
constant float3 lightSpecularColor = float3(1.0, 1.0, 1.0);
constant bool hasColorTexture [[function_constant(0)]];


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


vertex VertexOut vertex_main(VertexIn vertexBuffer [[stage_in]],
                             constant Uniforms &uniforms [[buffer(21)]]
                             ) {
    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexBuffer.position;
    out.worldNormal = (uniforms.modelMatrix * float4(vertexBuffer.normal, 0)).xyz;
    out.worldPosition = (uniforms.modelMatrix * vertexBuffer.position).xyz;
    out.uv = vertexBuffer.uv;
    return out;
}

vertex VertexOut vertex_instances(VertexIn vertexBuffer [[stage_in]],
                                  constant Uniforms &uniforms [[buffer(21)]],
                                  constant Instances *instances [[buffer(20)]],
                                  uint instanceID [[instance_id]]) {
    Instances instance = instances[instanceID];

    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * instance.modelMatrix * vertexBuffer.position;
    out.worldNormal = (uniforms.modelMatrix * instance.modelMatrix * float4(vertexBuffer.normal, 0)).xyz;
    out.worldPosition = (uniforms.modelMatrix * instance.modelMatrix * vertexBuffer.position).xyz;
    out.uv = vertexBuffer.uv;
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant Material &material [[buffer(11)]],
                              constant FragmentUniforms &fragmentUniforms [[buffer(22)]],
                              texture2d<float>baseColorTexture [[texture(0), function_constant(hasColorTexture)]]) {
    float3 baseColor;
    if (hasColorTexture) {
        const sampler s(filter::linear);
        baseColor = baseColorTexture.sample(s, in.uv).rgb;
    } else {
        baseColor = material.baseColor;
    }


    // diffuse
    float3 lightVector = normalize(lightPosition);
    float3 normalVector = normalize(in.worldNormal);
    float diffuseIntensity = saturate(dot(lightVector, normalVector));
    float3 diffuseColor = baseColor * diffuseIntensity;

    // ambient
    float3 ambientColor = baseColor * ambientLightColor * ambientLightIntensity;

    // specular
    float  materialShininess = material.shininess;
    float3 materialSpecularColor = material.specularColor;
    float3 reflection = reflect(lightVector, normalVector);
    float3 cameraVector = normalize(in.worldPosition - fragmentUniforms.cameraPosition);
    float specularIntensity = pow(saturate(dot(reflection, cameraVector)), materialShininess);
    float3 specularColor = lightSpecularColor * materialSpecularColor * specularIntensity;

    // result color
    float3 color = diffuseColor + ambientColor + specularColor;

    return float4 (color, 1);
}
