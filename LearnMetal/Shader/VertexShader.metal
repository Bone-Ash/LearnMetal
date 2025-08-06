//
//  VertexShader.metal
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

#include "Common.metal"

// vertex: - Metal 修饰符，用于表示该函数为顶点着色器
// VertexOut: - 函数返回值
// vertex_main: - 函数名
// VertexIn in [[stage_in]]: - 输入参数，顶点数据
// constant Uniforms &uniforms [[buffer(1)]]: - uniform 传进来的变换矩阵
vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             // constant: - 表示 uniform 是只读的，通常视图矩阵由 CPU 计算，所以不需要修改，所以防止意外改动，将其设置为只读
                             // Uniforms: - 表示会解析成这个数据结构
                             // &uniforms: - 表示会引用缓冲区的数据源作为 uniforms，而不会创建一个新的实例
                             // [[buffer(1)]]: - 表示数据源来自传递来的 Buffer 1，根据 setVertexBuffer 的 index 来定
                             constant Uniforms &uniforms [[buffer(1)]])
{
    VertexOut out;
    
    // 模型坐标 -> 世界坐标
    float4 worldPosition = uniforms.modelMatrix * float4(in.position, 1.0);
    // 世界坐标 -> 视图坐标
    float4 viewPosition = uniforms.viewMatrix * worldPosition;
    // 视图坐标 -> 裁剪坐标
    out.position = uniforms.projectionMatrix * viewPosition;
    // 归一化法线
    out.normal = normalize(uniforms.normalMatrix * in.normal);
    
    return out;
}
