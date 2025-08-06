//
//  MetalView.swift
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

import SwiftUI
import MetalKit

struct MetalView: ViewRepresentable {
    // MARK: - Metal Device
    private let device: MTLDevice
    private let renderer: Renderer
    
    init() {
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported")
        }
        
        // 检查 Metal 4 支持
        guard defaultDevice.supportsFamily(.metal4) else {
            fatalError("Metal 4 is not supported on this device")
        }
        self.device = defaultDevice
        
        do {
            self.renderer = try Renderer(device: device)
        } catch {
            print("Failed to create Metal 4 renderer: \(error)")
            fatalError("Failed to create Metal 4 renderer: \(error)")
        }
    }
    
    // MARK: - 创建视图
#if os(macOS)
    func makeNSView(context: Context) -> MTKView {
        return makeView()
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        // 更新逻辑
    }
#else
    func makeUIView(context: Context) -> MTKView {
        return makeView()
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        // 更新逻辑
    }
#endif
    
    // 共享的视图创建逻辑
    private func makeView() -> MTKView {
        let mtkView = MTKView(frame: .zero, device: device)
        // 配置渲染格式
        mtkView.colorPixelFormat = .bgra8Unorm
        // 设置渲染器代理，分离 UI 和 Renderer
        mtkView.delegate = renderer
        // 配置其他渲染属性
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return mtkView
    }
}

#Preview {
    MetalView()
}
