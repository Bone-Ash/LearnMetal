//
//  Environment.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import simd

enum Environment {
    static let mainLight: Light = Light(
        direction: SIMD3<Float>(1, -1, -1),
        color: SIMD3<Float>(1, 1, 1),
        intensity: 0.5
    )
    
    static var camera = Camera(
        position: SIMD3<Float>(0, 1, 15),
        target: SIMD3<Float>(0, 0, 0),
        up: SIMD3<Float>(0, 1, 0)
    )
}
