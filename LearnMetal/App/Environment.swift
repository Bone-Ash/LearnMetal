//
//  Environment.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import simd

enum Environment {
    static var camera = Camera(
        position: SIMD3<Float>(0, 1, 3),
        target: SIMD3<Float>(0, 0, 0),
        up: SIMD3<Float>(0, 1, 0)
    )
}
