//
//  MeshBuffers.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import ModelIO
import MetalKit

struct MeshBuffers {
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let indexCount: Int
    let mdlVertexDescriptor: MDLVertexDescriptor

    init?(asset: MDLAsset, device: MTLDevice) {
        guard let mdlMesh = asset.object(at: 0) as? MDLMesh else { return nil }
        self.mdlVertexDescriptor = mdlMesh.vertexDescriptor

        // 用 MTKMesh 转换为 Metal buffer
        guard let mtkMesh = try? MTKMesh(mesh: mdlMesh, device: device) else { return nil }
        guard let vertexBuffer = mtkMesh.vertexBuffers.first?.buffer else { return nil }
        guard let submesh = mtkMesh.submeshes.first else { return nil }
        self.vertexBuffer = vertexBuffer
        self.indexBuffer = submesh.indexBuffer.buffer
        self.indexCount = submesh.indexCount
    }
}
