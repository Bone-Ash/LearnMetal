//
//  Light.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

struct Light {
    // Lambertian 光照
    var direction: SIMD3<Float> // 方向
    var color: SIMD3<Float>     // 颜色
    var intensity: Float        // 强度
    // Blinn Phone 光照
    var specularColor: SIMD3<Float>   // 高光颜色
    var specularIntensity: Float      // 高光强度
    var shininess: Float              // 高光指数
}
