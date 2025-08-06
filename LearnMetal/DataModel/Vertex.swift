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
    // 前面 (红)
    Vertex(position: SIMD3(-0.5, -0.5,  0.5), color: SIMD4(1, 0, 0, 1)),
    Vertex(position: SIMD3( 0.5, -0.5,  0.5), color: SIMD4(1, 0, 0, 1)),
    Vertex(position: SIMD3( 0.5,  0.5,  0.5), color: SIMD4(1, 0, 0, 1)),
    Vertex(position: SIMD3(-0.5,  0.5,  0.5), color: SIMD4(1, 0, 0, 1)),
    // 右面 (绿)
    Vertex(position: SIMD3( 0.5, -0.5,  0.5), color: SIMD4(0, 1, 0, 1)),
    Vertex(position: SIMD3( 0.5, -0.5, -0.5), color: SIMD4(0, 1, 0, 1)),
    Vertex(position: SIMD3( 0.5,  0.5, -0.5), color: SIMD4(0, 1, 0, 1)),
    Vertex(position: SIMD3( 0.5,  0.5,  0.5), color: SIMD4(0, 1, 0, 1)),
    // 后面 (蓝)
    Vertex(position: SIMD3( 0.5, -0.5, -0.5), color: SIMD4(0, 0, 1, 1)),
    Vertex(position: SIMD3(-0.5, -0.5, -0.5), color: SIMD4(0, 0, 1, 1)),
    Vertex(position: SIMD3(-0.5,  0.5, -0.5), color: SIMD4(0, 0, 1, 1)),
    Vertex(position: SIMD3( 0.5,  0.5, -0.5), color: SIMD4(0, 0, 1, 1)),
    // 左面 (黄)
    Vertex(position: SIMD3(-0.5, -0.5, -0.5), color: SIMD4(1, 1, 0, 1)),
    Vertex(position: SIMD3(-0.5, -0.5,  0.5), color: SIMD4(1, 1, 0, 1)),
    Vertex(position: SIMD3(-0.5,  0.5,  0.5), color: SIMD4(1, 1, 0, 1)),
    Vertex(position: SIMD3(-0.5,  0.5, -0.5), color: SIMD4(1, 1, 0, 1)),
    // 上面 (品红)
    Vertex(position: SIMD3(-0.5,  0.5,  0.5), color: SIMD4(1, 0, 1, 1)),
    Vertex(position: SIMD3( 0.5,  0.5,  0.5), color: SIMD4(1, 0, 1, 1)),
    Vertex(position: SIMD3( 0.5,  0.5, -0.5), color: SIMD4(1, 0, 1, 1)),
    Vertex(position: SIMD3(-0.5,  0.5, -0.5), color: SIMD4(1, 0, 1, 1)),
    // 下面 (青)
    Vertex(position: SIMD3(-0.5, -0.5, -0.5), color: SIMD4(0, 1, 1, 1)),
    Vertex(position: SIMD3( 0.5, -0.5, -0.5), color: SIMD4(0, 1, 1, 1)),
    Vertex(position: SIMD3( 0.5, -0.5,  0.5), color: SIMD4(0, 1, 1, 1)),
    Vertex(position: SIMD3(-0.5, -0.5,  0.5), color: SIMD4(0, 1, 1, 1)),
]

let indices: [UInt32] = [
    // 前面
    0, 1, 2,  2, 3, 0,
    // 右面
    4, 5, 6,  6, 7, 4,
    // 后面
    8, 9,10, 10,11, 8,
    // 左面
    12,13,14, 14,15,12,
    // 上面
    16,17,18, 18,19,16,
    // 下面
    20,21,22, 22,23,20
]
