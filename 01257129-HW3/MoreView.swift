import SwiftUI

// MARK: - 主畫面
struct MoreView: View {

    // 自適應欄位：每格最小寬度 140，行間距 8
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 140), spacing: 8)
    ]

    // 從外部資料提供者讀取
    private var data: [GalleryCategory: [GalleryItem]] = GalleryData.data

    // 動畫/彈出狀態
    @State private var selectedItem: GalleryItem? = nil
    @Namespace private var ns

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders, .sectionFooters]) {

                    ForEach(GalleryCategory.allCases) { category in
                        let items = data[category] ?? []

                        Section {
                            // 分類內的格狀相片牆
                            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                                ForEach(items) { item in
                                    gridItemView(item)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                        } header: {
                            // 置頂 Header（Pinned）
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.background)
                                    .opacity(0.98)
                                    .overlay(Divider(), alignment: .bottom)
                                    .ignoresSafeArea()
                                Text(category.rawValue)
                                    .font(.title2.bold())
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("更多作品")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedItem) { item in
                DetailSheet(item: item, isPresented: Binding(
                    get: { selectedItem != nil },
                    set: { newValue in
                        if !newValue { selectedItem = nil }
                    }
                ))
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    // 單一格子
    @ViewBuilder
    private func gridItemView(_ item: GalleryItem) -> some View {
        let thumb = Group {
            if let ui = UIImage(named: item.imageName) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Rectangle().fill(.secondary.opacity(0.08))
                    VStack(spacing: 6) {
                        Image(systemName: "photo")
                            .font(.system(size: 22))
                            .foregroundStyle(.secondary)
                        Text(item.imageName)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }
            }
        }

        thumb
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.secondary.opacity(0.15), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .scaleEffect(selectedItem?.id == item.id ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: selectedItem?.id)
            .onTapGesture {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    selectedItem = item
                }
            }
            .accessibilityLabel("\(item.imageName)")
    }
}

// MARK: - 詳情彈出頁（圖片 + 圖解）
private struct DetailSheet: View {
    let item: GalleryItem
    @Binding var isPresented: Bool

    @State private var scale: CGFloat = 0.94
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // 作品名稱
                        Text(item.title)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.primary)

                        // 放大圖片
                        if let ui = UIImage(named: item.imageName) {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(.secondary.opacity(0.15), lineWidth: 1)
                                )
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.secondary.opacity(0.1))
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 36))
                                        .foregroundStyle(.secondary)
                                    Text("找不到圖片：\(item.imageName)")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                            }
                            .frame(height: 220)
                        }

                        // 圖解區塊
                        diagramBlock(for: item.diagram)
                    }
                    .padding()
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            scale = 1.0
                            opacity = 1.0
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .navigationTitle("作品詳情")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("完成") {
                            isPresented = false
                        }
                        .bold()
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .presentationDetents([.large, .medium])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private func diagramBlock(for diagram: Diagram) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("圖解")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            switch diagram {
            case .text(let text):
                Text(text)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

            case .image(let name):
                if let ui = UIImage(named: name) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(.secondary.opacity(0.15), lineWidth: 1)
                        )
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.secondary.opacity(0.1))
                        VStack(spacing: 8) {
                            Image(systemName: "doc.text.image")
                                .font(.system(size: 28))
                                .foregroundStyle(.secondary)
                            Text("找不到圖解圖片：\(name)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                    .frame(height: 160)
                }

            case .images(let names):
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(names.enumerated()), id: \.offset) { _, name in
                        if let ui = UIImage(named: name) {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(.secondary.opacity(0.15), lineWidth: 1)
                                )
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.secondary.opacity(0.1))
                                VStack(spacing: 8) {
                                    Image(systemName: "doc.text.image")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.secondary)
                                    Text("找不到圖解圖片：\(name)")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                            }
                            .frame(height: 160)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MoreView()
    }
}
