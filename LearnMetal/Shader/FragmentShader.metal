//
//  FragmentShader.metal
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

#include "Common.metal" // 导入公共结构体定义

// 片元着色器函数
// fragment: - Metal 修饰符，用于表示该函数为片元着色器
// float4: - 函数返回值，表示 RGBA 颜色值
// fragment_main: - 函数名
// VertexOut in: - 输入参数，传入顶点着色器输出的结构体 VertexOut
fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant Uniforms &uniforms [[buffer(0)]])
{
    float3 normal = in.normal;
    float3 worldPosition = in.worldPosition;
    float3 viewDirection = normalize(uniforms.cameraPosition - worldPosition);
    float3 lightDirection = normalize(-uniforms.mainLight.direction);
    
    float3 H = normalize(lightDirection + viewDirection);
    float3 specular = uniforms.mainLight.specularColor * uniforms.mainLight.specularIntensity * pow(max(dot(normal, H), 0.0), uniforms.mainLight.shininess);
    
    float NdotL = max(dot(normal, lightDirection), 0.0);
    
    float3 baseColor = float3(1, 1, 1);
    float3 diffuse = NdotL * uniforms.mainLight.color * uniforms.mainLight.intensity;
    float3 color = baseColor * diffuse;
    
    float3 ambient = float3(0.05, 0.05, 0.05);
    color += ambient;
    color += specular;
    
    return float4(color, 1.0);
}
