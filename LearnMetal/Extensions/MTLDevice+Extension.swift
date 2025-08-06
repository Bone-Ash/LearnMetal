//
//  MTLDevice+Extension.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import Metal

extension MTLDevice {
    // 创建命令队列
    func makeMainCommandQueue(label: String = "Main Command Queue") throws -> MTL4CommandQueue {
        let queueDescriptor = MTL4CommandQueueDescriptor()
        queueDescriptor.label = label
        return try self.makeMTL4CommandQueue(descriptor: queueDescriptor)
    }
    
    // 创建编译器
    func makeMainCompiler(label: String = "Main Compiler") throws -> MTL4Compiler {
        let compilerDescriptor = MTL4CompilerDescriptor()
        compilerDescriptor.label = label
        return try self.makeCompiler(descriptor: compilerDescriptor)
    }
    
    // 创建命令缓冲区
    func makeMainCommandBuffer(label: String = "Reusable Command Buffer") throws -> MTL4CommandBuffer {
        guard let commandBuffer = self.makeCommandBuffer() else {
            throw RendererError.failedToCreateCommandBuffer
        }
        commandBuffer.label = label
        return commandBuffer
    }
    
    // 创建命令分配器
    func makeFrameAllocators(count: Int) throws -> [MTL4CommandAllocator] {
        return try (0..<count).map { index in
            let allocatorDescriptor = MTL4CommandAllocatorDescriptor()
            allocatorDescriptor.label = "Frame Allocator \(index)"
            return try self.makeCommandAllocator(descriptor: allocatorDescriptor)
        }
    }
}
