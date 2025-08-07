//
//  Uniforms.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import simd

/// Uniform 数据结构
struct Uniforms {
    let modelMatrix: float4x4
    let viewMatrix: float4x4
    let projectionMatrix: float4x4
    let normalMatrix: float3x3 // 法线矩阵
    let cameraPosition: SIMD3<Float> // 相机位置
    let mainLight: Light // 主光源
}
