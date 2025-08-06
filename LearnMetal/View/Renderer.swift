//
//  Renderer.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import SwiftUI
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    
    // MARK: - 配置
    private let kMaxFramesInFlight = 3              // 三重缓冲
    
    // MARK: - Metal 4 核心组件
    let device: MTLDevice                           // GPU 设备
    let commandQueue: MTL4CommandQueue              // 命令队列
    let commandBuffer: MTL4CommandBuffer            // Metal 命令 Buffer
    let compiler: MTL4Compiler                      // Metal 编译器
    let commandAllocators: [MTL4CommandAllocator]   // 命令分配器
    
    // MARK: - 渲染状态
    var depthState: MTLDepthStencilState?           // 深度测试状态
    var pipelineState: MTLRenderPipelineState?      // 渲染管线状态
    
    // MARK: - 参数表
    var vertexArgumentTable: MTL4ArgumentTable?     // 顶点着色器参数表
    var fragmentArgumentTable: MTL4ArgumentTable?   // 片元着色器参数表
    
    // MARK: - 缓冲区
    private var uniformBuffers: [MTLBuffer] = []    // Uniform 缓冲区
    private var meshBuffers: MeshBuffers?
    
    // MARK: - 状态
    private var frameNumber: Int = 0
    
    init(device: MTLDevice) throws {
        self.device = device
        
        // MARK: - 配置命令队列
        self.commandQueue = try device.makeMainCommandQueue()
        self.commandBuffer = try device.makeMainCommandBuffer()
        self.compiler = try device.makeMainCompiler()
        self.commandAllocators = try device.makeFrameAllocators(count: kMaxFramesInFlight)
        
        
        // MARK: - 加载模型
        guard let objModel = ModelLoader.loadModel(named: "truncated icosahedron", ext: "obj", device: device) else {
            throw RendererError.failedToLoadModel
        }
        guard let mesh = MeshBuffers(asset: objModel, device: device) else {
            throw RendererError.failedToLoadModel
        }
        self.meshBuffers = mesh
        
        let vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.mdlVertexDescriptor)
        
        
        // MARK: - 设置参数表
        // 顶点参数表
        let vertexArgTableDescriptor = MTL4ArgumentTableDescriptor()
        vertexArgTableDescriptor.maxBufferBindCount = 2
        self.vertexArgumentTable = try device.makeArgumentTable(descriptor: vertexArgTableDescriptor)
        
        // 片段参数表
        let fragmentArgTableDescriptor = MTL4ArgumentTableDescriptor()
        fragmentArgTableDescriptor.maxBufferBindCount = 1
        self.fragmentArgumentTable = try device.makeArgumentTable(descriptor: fragmentArgTableDescriptor)
        
        
        // MARK: - 配置缓冲区
        // Uniform 缓冲区
        self.uniformBuffers = try (0..<kMaxFramesInFlight).map { index in
            guard let uniformBuffer = device.makeBuffer(
                length: MemoryLayout<Uniforms>.size,
                options: .storageModeShared
            ) else {
                throw RendererError.failedToCreateUniformBuffer
            }
            uniformBuffer.label = "Uniform Buffer \(index)"
            return uniformBuffer
        }
        
        // MARK: - 配置渲染管线
        // 加载 Shader 库
        guard let library = device.makeDefaultLibrary() else {
            throw RendererError.failedToLoadLibrary
        }
        let vertexFunctionDescriptor       = MTL4LibraryFunctionDescriptor()
        vertexFunctionDescriptor.library   = library
        vertexFunctionDescriptor.name      = "vertex_main"
        
        let fragmentFunctionDescriptor     = MTL4LibraryFunctionDescriptor()
        fragmentFunctionDescriptor.library = library
        fragmentFunctionDescriptor.name    = "fragment_main"
        
        
        // MARK: - 渲染管线描述符
        let pipelineDescriptor = MTL4RenderPipelineDescriptor()
        pipelineDescriptor.vertexFunctionDescriptor        = vertexFunctionDescriptor
        pipelineDescriptor.fragmentFunctionDescriptor      = fragmentFunctionDescriptor
        pipelineDescriptor.vertexDescriptor                = vertexDescriptor
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.inputPrimitiveTopology          = .triangle
        pipelineDescriptor.isRasterizationEnabled          = true
        pipelineDescriptor.rasterSampleCount               = 1
        
        
        // MARK: - 深度测试
        // 创建深度模板状态
        let depthStateDescriptor = MTLDepthStencilDescriptor()
        depthStateDescriptor.depthCompareFunction = .less
        depthStateDescriptor.isDepthWriteEnabled = true
        self.depthState = device.makeDepthStencilState(descriptor: depthStateDescriptor)
        
        // 创建渲染管线状态
        self.pipelineState = try compiler.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    func draw(in view: MTKView) {
        
        // MARK: - 准备编码
        guard let pipelineState         = pipelineState,
              let depthState            = depthState,
              let vertexArgumentTable   = vertexArgumentTable,
              let fragmentArgumentTable = fragmentArgumentTable,
              let mesh                  = meshBuffers,
              let drawable              = view.currentDrawable
        else { return }
        
        commandBuffer.label = "Frame \(frameNumber) Command Buffer"
        
        // 当前帧索引
        let frameIndex = frameNumber % kMaxFramesInFlight
        let frameAllocator = commandAllocators[frameIndex]
        let uniformBuffer = uniformBuffers[frameIndex]
        
        // 等待 drawable 可用
        commandQueue.waitForDrawable(drawable)
        
        // 重置分配器并开始命令缓冲区
        frameAllocator.reset()
        
        
        // MARK: - 开始编码
        commandBuffer.beginCommandBuffer(allocator: frameAllocator)
        
        // 更新 Uniforms
        updateUniforms(uniformBuffer: uniformBuffer, view: view)
        
        // 配置参数表
        vertexArgumentTable.setAddress(mesh.vertexBuffer.gpuAddress, index: 0)
        vertexArgumentTable.setAddress(uniformBuffer.gpuAddress, index: 1)
        fragmentArgumentTable.setAddress(uniformBuffer.gpuAddress, index: 0)
        
        // 创建 Metal 4 渲染过程描述符
        let mtl4RenderPassDescriptor = MTL4RenderPassDescriptor()
        mtl4RenderPassDescriptor.colorAttachments[0].texture     = drawable.texture
        mtl4RenderPassDescriptor.colorAttachments[0].loadAction  = .clear
        mtl4RenderPassDescriptor.colorAttachments[0].storeAction = .store
        mtl4RenderPassDescriptor.colorAttachments[0].clearColor  = MTLClearColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0)
        mtl4RenderPassDescriptor.renderTargetWidth = Int(view.drawableSize.width)
        mtl4RenderPassDescriptor.renderTargetHeight = Int(view.drawableSize.height)
        
        // 创建渲染编码器
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(
            descriptor: mtl4RenderPassDescriptor,
            options: MTL4RenderEncoderOptions()
        ) else { return }
        
        
        // 设置渲染状态
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setArgumentTable(vertexArgumentTable, stages: .vertex)
        renderEncoder.setArgumentTable(fragmentArgumentTable, stages: .fragment)
        
        // MARK: - 绘制
        renderEncoder.drawIndexedPrimitives(
            primitiveType: .triangle,
            indexCount: mesh.indexCount,
            indexType: .uint32,
            indexBuffer: mesh.indexBuffer.gpuAddress,
            indexBufferLength: MemoryLayout<UInt32>.size * mesh.indexCount
        )
        
        
        // MARK: - 完成编码
        renderEncoder.endEncoding()
        commandBuffer.endCommandBuffer()
        
        // 通知 GPU 渲染完成
        commandQueue.signalDrawable(drawable)
        
        // 提交命令
        commandQueue.commit([commandBuffer], options: nil)
        
        // 呈现 drawable
        drawable.present()
        
        frameNumber += 1
    }
    
    // MARK: - Uniform 更新
    private func updateUniforms(uniformBuffer: MTLBuffer, view: MTKView) {
        // 计算当前时间产生旋转
        let time = CACurrentMediaTime()
        let angle = Float(time) * 0.5
        let modelMatrix = float4x4(rotationY: angle)
        
        let viewMatrix = Environment.camera.viewMatrix
        
        let aspect = Float(view.drawableSize.width / view.drawableSize.height)
        let projectionMatrix = perspective(
            aspect: aspect,
            fovy: .pi / 3,
            near: 0.1,
            far: 100
        )
        
        let invTrans = modelMatrix.inverse.transpose
        let normalMatrix = simd_float3x3(
            SIMD3<Float>(invTrans.columns.0.x, invTrans.columns.0.y, invTrans.columns.0.z),
            SIMD3<Float>(invTrans.columns.1.x, invTrans.columns.1.y, invTrans.columns.1.z),
            SIMD3<Float>(invTrans.columns.2.x, invTrans.columns.2.y, invTrans.columns.2.z)
        )
        
        var uniforms = Uniforms(
            modelMatrix: modelMatrix,
            viewMatrix: viewMatrix,
            projectionMatrix: projectionMatrix,
            normalMatrix: normalMatrix,
            mainLight: Environment.mainLight
        )
        
        // 复制到 GPU 缓冲区
        memcpy(uniformBuffer.contents(), &uniforms, MemoryLayout<Uniforms>.size)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
//        print("Drawable size changed to: \(size)")
    }
}

#Preview {
    MetalView()
}

// MARK: - 错误定义
enum RendererError: Error {
    case failedToLoadModel
    case failedToCreateCommandBuffer
    case failedToLoadLibrary
    case failedToCreateVertexBuffer
    case failedToCreateIndexBuffer
    case failedToCreateUniformBuffer
}
