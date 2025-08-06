//
//  LookAt.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import simd

/// 计算视图矩阵 View Matrix
/// - Parameters:
///   - eye: 相机的位置
///   - center: 相机要看向的目标点
///   - up: 相机的上方向
/// - Returns: 视图矩阵 View Matrix
func lookAt(eye: SIMD3<Float>, center: SIMD3<Float>, up: SIMD3<Float>) -> float4x4 {
    /// **计算相机的前方向 (相机朝向的方向)**
    /// `eye - center` 得到从相机位置 `eye` 指向目标点 `center` 的方向向量
    /// `normalize(eye - center)` 让它变成单位向量，保证方向正确但长度为 1
    let zAxis = normalize(eye - center)
    
    /// **计算相机的右方向 (X 轴)**
    /// `cross(up, zAxis)` 计算出一个**垂直于 `up` 和 `zAxis` 的向量**，表示相机的右方向
    /// `normalize(...)` 确保它是单位向量
    let xAxis = normalize(cross(up, zAxis))
    
    /// **计算相机的真实上方向 (Y 轴)**
    /// `cross(zAxis, xAxis)` 计算出一个**垂直于 `zAxis` 和 `xAxis` 的向量**，保证坐标系正交
    let yAxis = cross(zAxis, xAxis)
    
    /// **构造视图矩阵**
    /// 旋转部分 (前三行)：定义相机的方向
    /// 平移部分 (最后一行)：让 `eye` 变成 `(0,0,0)`，确保相机位于原点
    return float4x4(
        SIMD4<Float>( xAxis.x, yAxis.x, zAxis.x, 0),
        SIMD4<Float>( xAxis.y, yAxis.y, zAxis.y, 0),
        SIMD4<Float>( xAxis.z, yAxis.z, zAxis.z, 0),
        SIMD4<Float>(-dot(xAxis, eye), -dot(yAxis, eye), -dot(zAxis, eye), 1)
    )
}
