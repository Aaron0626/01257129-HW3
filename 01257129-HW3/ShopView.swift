import SwiftUI

struct ShopView: View {
    private let urlString: String = "https://shopee.tw/list/%E6%AF%9B%E7%B7%9A?is_from_signup=true"

    @State private var showSafari: Bool = false
    @State private var url: URL? = nil
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            // 假設 AppBackground() 是您自訂的背景 View
            AppBackground().ignoresSafeArea()

            NavigationStack {
                VStack(spacing: 16) {
                    // 標題與說明
                    VStack(spacing: 8) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 44, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.orange)

                        Text("商鋪")
                            .font(.largeTitle.bold())
                    }
                    Button {
                        if let u = URL(string: urlString) {
                            url = u
                            showSafari = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "safari")
                                .imageScale(.medium)
                            Text("打開商店")
                                .font(.headline)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            Capsule()
                                .fill(.orange.opacity(0.15))
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("打開商店")
                    .accessibilityHint("以內建瀏覽器開啟賣場頁面")

                    Spacer()
                }
                .padding(.top, 80)
                .padding(.horizontal)
                .navigationTitle("商鋪")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showSafari) {
            if let url {
                // 假設 InAppSafariView 是您用 SFSafariViewController 封裝的 View
                InAppSafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
#Preview {
    ShopView()
}
