//
//  ToolView.swift
//  01257129-HW3
//
//  Created by user10 on 2025/10/22.
//

import SwiftUI

private let introFontName = "ChenYuluoyan-2.0-Thin"

struct ToolView: View {

    struct Tool: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let symbol: String
    }

    private let tools: [Tool] = [
        .init(name: "毛線", symbol: "gyroscope"),
        .init(name: "鉤針", symbol: "wand.and.sparkles.inverse"),
        .init(name: "棒針", symbol: "pencil.and.outline"),
        .init(name: "其他", symbol: "shippingbox.circle.fill")
    ]

    private func color(for toolName: String) -> Color {
        switch toolName {
        case "毛線": return .indigo
        case "鉤針": return .orange
        case "棒針": return .blue
        case "其他": return .gray
        default: return .secondary
        }
    }

    private func toHomeTool(_ t: Tool) -> HomeView.Tool {
        HomeView.Tool(name: t.name, symbol: t.symbol)
    }

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            NavigationStack {
                List {
                    // 用 Section header 當作上方提示，能自然與導航列保持距離
                    Section {
                        EmptyView()
                    } header: {
                        TipBubble(
                            symbol: "lightbulb.max.fill",
                            text: "保持線的張力一致，針目才會整齊！初學者可先用淺色粗線，較容易看清針目。"
                        )
                        .font(.custom(introFontName, size: 25).bold())
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.secondary.opacity(0.15), .secondary.opacity(0.55)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                        .padding(.top, 100)
                    }

                    // 準備工具 - 導覽項目
                    Section {
                        ForEach(tools) { tool in
                            switch tool.name {
                            case "毛線":
                                NavigationLink {
                                    YarnMaterialList()
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: tool.symbol)
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(color(for: tool.name))
                                            .frame(width: 28)
                                        Text(tool.name)
                                            .font(.title3.weight(.semibold))
                                            .foregroundStyle(.primary)
                                    }
                                    .padding(.vertical, 6)
                                }

                            case "鉤針":
                                NavigationLink {
                                    CrochetHookDetail()
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: tool.symbol)
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(color(for: tool.name))
                                            .frame(width: 28)
                                        Text(tool.name)
                                            .font(.title3.weight(.semibold))
                                            .foregroundStyle(.primary)
                                    }
                                    .padding(.vertical, 6)
                                }

                            case "棒針":
                                NavigationLink {
                                    NeedleTypeList()
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: tool.symbol)
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(color(for: tool.name))
                                            .frame(width: 28)
                                        Text(tool.name)
                                            .font(.title3.weight(.semibold))
                                            .foregroundStyle(.primary)
                                    }
                                    .padding(.vertical, 6)
                                }

                            default:
                                NavigationLink {
                                    ToolDetailBasic(tool: toHomeTool(tool))
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: tool.symbol)
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(color(for: tool.name))
                                            .frame(width: 28)
                                        Text(tool.name)
                                            .font(.title3.weight(.semibold))
                                            .foregroundStyle(.primary)
                                    }
                                    .padding(.vertical, 6)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .background(AppBackground())
                .ignoresSafeArea()
                .navigationTitle("工具")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ToolView()
}
