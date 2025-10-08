import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("首頁", systemImage: "house") {
                HomeView()
            }
            Tab("工具", systemImage: "apple.writing.tools") {
                ToolView()
            }
            Tab("基礎", systemImage: "wand.and.outline.inverse") {
                FoundationView()
            }
            Tab("進階", systemImage: "sparkles") {
                AdvancedView()
            }
            Tab("更多作品", systemImage: "wand.and.sparkles.inverse") {
                MoreView()
            }
            Tab("商鋪", systemImage: "cart.fill") {
                ShopView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
