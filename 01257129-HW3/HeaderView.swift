// HeaderView.swift
// 頂部 Hero Header：背景圖/漸層 + 訂閱/主題切換 + 標題與副標
import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
struct HeaderView: View {
    let title: String          // 主標題
    let subtitle: String       // 副標題
    let bgImageName: String    // 背景圖片（Assets 名稱）
    @Binding var isDarkMode: Bool        // 是否為深色模式（與 ContentView 同步）
    @Binding var animateScissors: Bool   // 用於控制圖示動畫的狀態
    @Binding var isSubscribed: Bool      // 訂閱狀態（@AppStorage 在外層綁定）

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [Color.pink.opacity(0.6), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)

            // 下方遮罩漸層：提升文字可讀性
            LinearGradient(
                colors: [Color.black.opacity(0.35), Color.black.opacity(0.1)],
                startPoint: .bottom,
                endPoint: .top
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Spacer()
                    // 深/淺色模式切換
                    GlassPill {
                        HStack(spacing: 8) {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(isDarkMode ? .yellow.opacity(0.9) : .orange.opacity(0.9))
                                .frame(width: 18)
                            Text(isDarkMode ? "Dark" : "Light")
                                .font(.custom(introFontName, size: 20).bold())
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                isDarkMode.toggle()
                            }
                        }
                    }
                }
                // 標題與副標
                Text(title)
                    .font(.custom(introFontName, size: 60).bold())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

                Text(subtitle)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 12)
    }
}
