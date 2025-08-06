//
//  Float4x4+Extension.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import simd

// MARK: - 辅助扩展
extension float4x4 {
    /// 绕 Y 轴的旋转矩阵
    init(rotationY angle: Float) {
        self = float4x4(
            SIMD4<Float>( cos(angle), 0,  sin(angle), 0),
            SIMD4<Float>( 0,         1,  0,          0),
            SIMD4<Float>(-sin(angle), 0,  cos(angle), 0),
            SIMD4<Float>( 0,         0,  0,          1)
        )
    }
}
