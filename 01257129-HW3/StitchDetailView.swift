import SwiftUI
import AVKit
import SafariServices

private let introFontName = "ChenYuluoyan-2.0-Thin"

// 內嵌 Safari 視圖（SFSafariViewController 的 SwiftUI 包裝）
@MainActor
struct InAppSafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let cfg = SFSafariViewController.Configuration()
        cfg.entersReaderIfAvailable = false
        let vc = SFSafariViewController(url: url, configuration: cfg)
        return vc
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct StitchDetailView: View {
    let title: String
    let bundleVideoName: String?
    let remoteURL: URL?
    let description: String

    // 圖解與樣本圖片（Assets 名稱）
    let diagramImageName: String?
    let sampleImageName: String?

    // 僅進階針法使用不同的按鈕排版
    let isAdvanced: Bool

    @State private var showSafari: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    private var isYouTubeLink: Bool {
        guard let remoteURL else { return false }
        let host = remoteURL.host?.lowercased() ?? ""
        return host.contains("youtube.com") || host.contains("youtu.be")
    }

    // 單純的圖片區塊（若沒有圖片名稱 -> 完全不顯示，不用佔位）
    @ViewBuilder
    private func optionalImageBlock(title: String, imageName: String?, preferredHeight: CGFloat? = nil) -> some View {
        if
            let name = imageName,
            let uiImage = UIImage(named: name)
        {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: preferredHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.secondary.opacity(0.15), lineWidth: 1)
                    )
            }
        } else {
            // 不顯示任何東西（不用佔位）
            EmptyView()
        }
    }

    init(
        title: String,
        bundleVideoName: String?,
        remoteURL: URL?,
        description: String,
        diagramImageName: String?,
        sampleImageName: String?,
        isAdvanced: Bool = false
    ) {
        self.title = title
        self.bundleVideoName = bundleVideoName
        self.remoteURL = remoteURL
        self.description = description
        self.diagramImageName = diagramImageName
        self.sampleImageName = sampleImageName
        self.isAdvanced = isAdvanced
    }

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    if isAdvanced {
                        // 進階針法：標題與按鈕分開，避免擠壓標題排版
                        Text(title)
                            .font(.largeTitle.bold())
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)

                        if remoteURL != nil {
                            Button {
                                showSafari = true
                            } label: {
                                HStack(spacing: 6) {
                                    Spacer()
                                    Image(systemName: "safari")
                                    Text("以內建瀏覽器開啟")
                                }
                                .font(.callout.weight(.semibold))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("以內建瀏覽器開啟影片")
                            .accessibilityHint("在瀏覽器中觀看影片")
                        }
                    } else {
                        // 基礎/入門：維持原本 HStack 排版
                        HStack(alignment: .firstTextBaseline) {
                            Text(title)
                                .font(.largeTitle.bold())
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)

                            Spacer()

                            if remoteURL != nil {
                                Button {
                                    showSafari = true
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "safari")
                                        Text("以內建瀏覽器開啟")
                                    }
                                    .font(.callout.weight(.semibold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(
                                        Capsule().fill(.secondary.opacity(0.15))
                                    )
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("以內建瀏覽器開啟影片")
                                .accessibilityHint("在瀏覽器中觀看影片")
                            }
                        }
                    }

                    optionalImageBlock(title: "圖解", imageName: diagramImageName, preferredHeight: .infinity)

                    // 文字說明
                    Text(description)
                        .font(.custom(introFontName, size: 20))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    // 樣本圖片（若沒有 -> 不顯示，不佔位）
                    optionalImageBlock(title: "樣本", imageName: sampleImageName, preferredHeight: 300)
                }
                .padding()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSafari) {
            if let remoteURL {
                InAppSafariView(url: remoteURL).ignoresSafeArea()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
