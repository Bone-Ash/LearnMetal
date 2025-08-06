//
//  VertexShader.metal
//  LearnMetal
//
//  Created by GH on 8/6/25.
//

#include "Common.metal"

vertex VertexOut vertex_main(VertexIn in [[stage_in]])
{
    VertexOut out; // 定义 out 变量
    out.position = float4(in.position, 1.0); // 将输入的 position 赋值给 out.position
    out.color = in.color; // 将输入的 color 赋值给 out.color
    return out; // 返回 VertexOut 至 FragmentShader
}
