//
//  Shaders.metal
//  GameEngine Shared
//
//  Created by Matvey Kravtsov on 01/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "GameEngine/ShaderTypes.h"

constant float3 lightPosition = float3(2.0, 1.0, 0);
constant float3 ambientLightColor = float3(1.0, 1.0, 1.0);
constant float ambientLightIntensity = 0.4;
constant float3 specularLightColor = float3(1.0, 1.0, 1.0);

//constant float3 colorArray[] {
//    float3(1,0,0),
//    float3(0,1,0),
//    float3(0,0,1),
//    float3(1,0,1),
//    float3(0,1,1),
//    float3(1,1,0),
//};

struct VertexIn {
    float4 position [[attribute(0)]];
//    float3  color [[attribute(1)]];
    float3 normal [[attribute(1)]];
    float2 uv [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 worldPosition;
    float3 worldNormal;
    //    float3 color;
    float2 uv;
};


vertex VertexOut vertex_main(VertexIn vertexBuffer [[stage_in]],
//                             constant uint &colorID [[buffer(20)]],
                             constant Uniforms &uniforms [[buffer(21)]]
//                             constant float4x4 &modelMatrix [[buffer(21)]],
//                             constant float4x4 &viewMatrix [[buffer(22)]]
                             ) {
    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexBuffer.position;
//    out.color = colorArray[colorID];//float3(1,0,1);//vertexBuffer.color;
    out.worldNormal = (uniforms.modelMatrix * float4(vertexBuffer.normal, 0)).xyz;
    out.worldPosition = (uniforms.modelMatrix * vertexBuffer.position).xyz;
    out.uv = vertexBuffer.uv;
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant Material &material [[buffer(20)]],
                              constant FragmentUniforms &fragmentUniforms [[buffer(21)]],
                              texture2d<float>baseColorTexture [[texture(0)]]) {
//    return float4(in.uv, 0, 1);
    const sampler s(filter::linear);
    float3 baseColor = baseColorTexture.sample(s, in.uv).rgb;
//    float3 baseColor = material.baseColor;


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
    float3 specularColor = specularLightColor * materialSpecularColor * specularIntensity;

    // result color
    float3 color = diffuseColor + ambientColor + specularColor;

    return float4 (color, 1);
}
