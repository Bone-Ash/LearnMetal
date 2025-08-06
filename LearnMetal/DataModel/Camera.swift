//
//  Camera.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import simd

struct Camera {
    /// 世界空间下的相机位置（Position）
    var position: SIMD3<Float>
    /// 相机注视点（Target）
    var target: SIMD3<Float>
    /// 上方向（一般为(0, 1, 0)）
    var up: SIMD3<Float>

    /// 生成视图矩阵
    var viewMatrix: float4x4 {
        lookAt(eye: position, center: target, up: up)
    }

    /// 相机的前方向（归一化朝向向量，center - position）
    var forward: SIMD3<Float> {
        normalize(target - position)
    }

    /// 相机的右方向
    var right: SIMD3<Float> {
        normalize(cross(forward, up))
    }
}
