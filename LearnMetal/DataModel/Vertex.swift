//
//  Vertex.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

/// 顶点结构体
struct Vertex {
    /// 顶点坐标 XYZ
    var position: SIMD3<Float> // 位置
    /// 颜色 RGBA
    var color: SIMD4<Float>    // 颜色
}

let vertices: [Vertex] = [
    Vertex(position: SIMD3<Float>(0.0,  0.5, 0.0), color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0)),   // 顶点 1 (红色)
    Vertex(position: SIMD3<Float>(-0.5, -0.5, 0.0), color: SIMD4<Float>(0.0, 1.0, 0.0, 1.0)),  // 顶点 2 (绿色)
    Vertex(position: SIMD3<Float>(0.5, -0.5, 0.0), color: SIMD4<Float>(0.0, 0.0, 1.0, 1.0))    // 顶点 3 (蓝色)
]
