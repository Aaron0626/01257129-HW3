//
//  Card.swift
//  01257129-HW3
//
//  Created by user10 on 2025/10/22.
//

import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
/// 小型玻璃膠囊（適合小標籤或按鈕）
struct GlassPill<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(
                Capsule().fill(.ultraThinMaterial)
            )
            .overlay(
                Capsule().stroke(.white.opacity(0.15), lineWidth: 1)
            )
    }
}

struct TipBubble: View {
    let symbol: String // SFSymbol 名稱
    let text: String   // 說明文字

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.title3)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.yellow)
                .frame(width: 28)

            Text(text)
                .font(.custom(introFontName, size: 25).bold())
                .foregroundStyle(.primary)
            Spacer(minLength: 0)
        }
        .padding(14)
    }
}

