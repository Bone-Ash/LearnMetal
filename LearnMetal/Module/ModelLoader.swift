//
//  ModelLoader.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import ModelIO
import MetalKit

enum ModelLoader {
    static func loadModel(
        named filename: String,
        ext: String,
        device: MTLDevice
    ) -> MDLAsset? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("Cannot find file: \(filename).\(ext)")
            return nil
        }
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: url, vertexDescriptor: nil, bufferAllocator: allocator)
        
        guard asset.count > 0 else {
            print("No objects found in model file")
            return nil
        }
        
        // 检查第一个对象是否为 MDLMesh
        guard let mdlMesh = asset.object(at: 0) as? MDLMesh else {
            print("Cannot get mesh data")
            return nil
        }
        
        // 检查并补全法线
        if mdlMesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeNormal) == nil {
            print("No normal found, generating normals...")
            mdlMesh.addNormals(withAttributeNamed: MDLVertexAttributeNormal, creaseThreshold: 0.0)
        }
        
        print("MDLMesh vertex attributes:")
        for (i, attr) in mdlMesh.vertexDescriptor.attributes.enumerated() {
            if let a = attr as? MDLVertexAttribute, a.format != .invalid {
                print("  [attribute(\(i))] name: \(a.name), bufferIndex: \(a.bufferIndex), format: \(a.format.rawValue), offset: \(a.offset)")
            }
        }
        
        return asset
    }
}
