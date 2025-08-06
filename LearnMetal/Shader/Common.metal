//
//  Common.metal
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

// 公共头文件
#include <metal_stdlib>
using namespace metal;

// 顶点缓冲区(vertex buffer)传入顶点着色器所用的数据结构
struct VertexIn {
    float3 position [[attribute(0)]]; // 从顶点缓冲区中的第 0 个属性提取数据
    float3 normal   [[attribute(1)]]; // 从顶点缓冲区中的第 1 个属性提取数据
};

// 顶点着色器根据传入数据 VertexIn 进行一系列改动后，将输出数据打包成 VertexOut
struct VertexOut {
    float4 position [[position]]; // 标记为 [[position]] 意味着它是 屏幕坐标
    float3 normal;                // 法线
};

// 光照
struct Light {
    float3 direction; // 方向
    float3 color;     // 颜色
    float intensity;  // 强度
};

// 全局变量 Uniforms
struct Uniforms {
    float4x4 modelMatrix;       // 模型矩阵
    float4x4 viewMatrix;        // 视图矩阵
    float4x4 projectionMatrix;  // 投影矩阵
    float3x3 normalMatrix;      // 法线
    Light mainLight;            // 光照
};
