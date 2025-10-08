import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
// MARK: - Models
struct YarnMaterial: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
}

// MARK: - 其他工具的簡單說明頁
struct ToolDetailBasic: View {
    let tool: HomeView.Tool

    @State private var showFirstImage: Bool = true   // 僅用於提示框的切換預覽
    @State private var buttonScale: CGFloat = 1.0    // 小回彈動畫
    @State private var buttonGlow: Bool = false      // 短暫高亮
    @State private var showGuide: Bool = false       // 提示框（sheet）顯示
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    private func detailText(for name: String) -> String {
        switch name {
        case "鉤針":
            return "鉤針尺寸需搭配毛線粗細，常見尺寸如 2.5mm~6mm。握柄舒適能減少手部疲勞。"
        case "棒針":
            return "棒針常見材質有木、竹、金屬。需配合毛線粗細選用合適尺寸。"
        case "其他":
            // 不使用此文字，改用下方 List 呈現
            return ""
        default:
            return ""
        }
    }

    // 其他 -> 清單資料
    private struct OtherItem: Identifiable {
        let id = UUID()
        let title: String
        let imageName: String
    }

    private var otherItems: [OtherItem] {
        [
            .init(title: "記號扣", imageName: "other_marker"),
            .init(title: "縫線針", imageName: "other_needle"),
            .init(title: "剪刀", imageName: "other_scissors")
        ]
    }

    // 提示框內容（依狀態切換文案與主按鈕）
    @ViewBuilder
    private var guideSheetContent: some View {
        VStack(spacing: 16) {
            // 改成使用 FlipCard：前面顯示 change1，背面顯示 change2
            FlipCard(isFlipped: .constant(!showFirstImage), duration: 0.5, axis: (0,1), perspective: 0.7) {
                // Front
                Group {
                    if let ui = UIImage(named: "change1") {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: .infinity)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(.secondary.opacity(0.1))
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 36))
                                    .foregroundStyle(.secondary)
                                Text("找不到圖片：change1")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.secondary.opacity(0.15), lineWidth: 1)
                )
            } back: {
                // Back
                Group {
                    if let ui = UIImage(named: "change2") {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: .infinity)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(.secondary.opacity(0.1))
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 36))
                                    .foregroundStyle(.secondary)
                                Text("找不到圖片：change2")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.secondary.opacity(0.15), lineWidth: 1)
                )
            }

            // 文案
            Text(showFirstImage ? "首先準備好鉤針工具組" : "一隻可愛的小王子娃娃就完成啦～")
                .font(.custom(introFontName, size: 22))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)

            // 主按鈕（切換時觸發翻轉）
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showFirstImage.toggle()
                }
            } label: {
                Text(showFirstImage ? "事前準備已就緒" : "再鉤一隻吧")
                    .font(.headline)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule().fill(Color.accentColor.opacity(0.15))
                    )
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("otherGuidePrimaryButton")

            Spacer(minLength: 0)
        }
        .padding()
    }

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            Group {
                if tool.name == "其他" {
                    // 使用 List 呈現：不再顯示切換的頭圖（改為只有提示框內切換）
                    List {
                        Section("常用工具") {
                            ForEach(otherItems) { item in
                                VStack(spacing: 12) {
                                    Text(item.title)
                                        .font(.title3.weight(.semibold))
                                        .frame(width: 300, alignment: .leading)
                                        .foregroundStyle(.primary)
                                    if let uiImage = UIImage(named: item.imageName) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .stroke(.secondary.opacity(0.15), lineWidth: 1)
                                            )
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(.secondary.opacity(0.1))
                                            Image(systemName: "photo")
                                                .font(.system(size: 20))
                                                .foregroundStyle(.secondary)
                                        }
                                        .frame(width: 56, height: 56)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                } else {
                    // 其他以外 -> 維持原本的說明頁
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: tool.symbol)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 32, weight: .medium))
                                Text(tool.name)
                                    .font(.largeTitle.bold())
                                    .foregroundStyle(.primary)
                            }

                            Text(detailText(for: tool.name))
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(tool.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 僅在「其他」時顯示切換按鈕（改為彈出提示框）
                if tool.name == "其他" {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // 小回彈 + 高亮
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.65)) {
                                buttonScale = 1.12
                                buttonGlow = true
                            }
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8).delay(0.06)) {
                                buttonScale = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation(.easeOut(duration: 0.2)) { buttonGlow = false }
                            }
                            // 打開提示框（不直接切換圖片）
                            showGuide = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.2.squarepath")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(buttonGlow ? .secondary : .blue)
                            }
                            .padding(.horizontal, 4)
                            .scaleEffect(buttonScale)
                        }
                        .accessibilityIdentifier("otherChangeImageButton")
                    }
                }
            }
            // 提示框（Sheet）
            .sheet(isPresented: $showGuide) {
                ZStack {
                    AppBackground().ignoresSafeArea()
                    NavigationStack {
                        ScrollView {
                            guideSheetContent
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .navigationTitle("一鍵鉤織")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("關閉") {
                                    showGuide = false
                                }
                                .bold()
                            }
                        }
                    }
                    .toolbarBackground(.clear, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// iOS 17 的 contentTransition(.opacity) 與舊版備援
private struct ContentOpacityTransition: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.contentTransition(.opacity)
        } else {
            content.transition(.opacity)
        }
    }
}

// MARK: - 鉤針詳細頁：圖片 + 尺寸對照表
struct CrochetHookDetail: View {
    // 兩張鉤針圖（請確保已加入 Assets，名稱為 "etimo" 與 "etimo2"）
    private let hookImageNames: [String] = ["etimo", "etimo2"]

    @State private var showTips: Bool = false

    // 動畫狀態（按鈕）
    @State private var hookButtonScale: CGFloat = 1.0
    @State private var hookButtonGlow: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    private var tipsText: String {
        """
        實際選用請同時考量線材標示、個人手勁與作品需求。
        選擇合適的鉤針尺寸能讓針目更均勻、手感更舒適。
        """
    }

    struct HookRow: Identifiable {
        let id = UUID()
        let metric: String
        let jp: String
        let usage: String
    }

    private let rows: [HookRow] = [
        .init(metric: "2.0mm", jp: "2/0 號", usage: "細棉線、蕾絲線、極細毛線"),
        .init(metric: "2.5mm", jp: "4/0 號", usage: "細棉線、中細寶寶線"),
        .init(metric: "3.0mm", jp: "5/0 號", usage: "中小型玩偶、五股牛奶棉、一般中細線"),
        .init(metric: "3.5mm", jp: "6/0 號", usage: "中粗毛線、五股牛奶棉、輕薄圍巾"),
        .init(metric: "4.0mm", jp: "7/0 號", usage: "新手最常用、中粗棉線、一般毛線"),
        .init(metric: "5.0mm", jp: "8/0 號", usage: "粗線、粗棉繩、厚實毯子"),
        .init(metric: "6.0mm", jp: "10/0 號", usage: "粗布條線、粗皮草線、極粗毛線")
    ]

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // 可左右滑動的圖片輪播
                    if hookImageNames.contains(where: { UIImage(named: $0) != nil }) {
                        TabView {
                            ForEach(hookImageNames, id: \.self) { name in
                                if let uiImage = UIImage(named: name) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 260)
                                        .clipped()
                                } else {
                                    ZStack {
                                        Rectangle().fill(.secondary.opacity(0.08))
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo")
                                                .font(.system(size: 28, weight: .regular))
                                                .foregroundStyle(.secondary)
                                            Text("找不到圖片：\(name)")
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .frame(height: 260)
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(.secondary.opacity(0.15), lineWidth: 1)
                        )
                    } else {
                        // 若兩張都找不到，顯示占位
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(.secondary.opacity(0.1))
                            VStack(spacing: 8) {
                                Image(systemName: "wand.and.sparkles.inverse")
                                    .font(.system(size: 36, weight: .regular))
                                    .foregroundStyle(.secondary)
                                Text("找不到鉤針圖片資源")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                        .frame(height: 220)
                    }

                    // 標題與說明
                    Text("鉤針尺寸對照")
                        .font(.largeTitle.bold())

                    // 使用 List 呈現表格
                    List {
                        // 表頭（使用 Section header 自訂樣式）
                        Section {
                            ForEach(rows) { row in
                                HStack(alignment: .top, spacing: 12) {
                                    Text(row.metric)
                                        .frame(width: 100, alignment: .leading)
                                    Text(row.jp)
                                        .frame(width: 100, alignment: .leading)
                                    Text(row.usage)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .font(.body)
                                .foregroundStyle(.primary)
                                .padding(.vertical, 4)
                            }
                        } header: {
                            HStack {
                                Text("公制直徑 (mm)")
                                    .font(.headline)
                                    .frame(width: 100, alignment: .leading)
                                Text("日規號數")
                                    .font(.headline)
                                    .frame(width: 100, alignment: .leading)
                                Text("適用線材舉例")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .frame(minHeight: CGFloat(rows.count) * 44 + 80)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    Spacer(minLength: 0)
                }
                .padding()
            }
        }
        .navigationTitle("鉤針")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // 點擊動畫：放大回彈 + 短暫閃爍
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                        hookButtonScale = 1.15
                        hookButtonGlow = true
                    }
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7).delay(0.08)) {
                        hookButtonScale = 1.0
                    }
                    // 關閉發光
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            hookButtonGlow = false
                        }
                    }
                    // 開啟提示
                    showTips = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "info.bubble")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(hookButtonGlow ? .secondary :.orange)
                    }
                    .padding(.horizontal, 4)
                    .scaleEffect(hookButtonScale)
                }
                .accessibilityIdentifier("hookTipsButton")
            }
        }
        .sheet(isPresented: $showTips) {
            ZStack {
                AppBackground().ignoresSafeArea()
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(tipsText)
                                .font(.custom(introFontName, size: 18))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .navigationTitle("小提醒")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("完成") {
                                showTips = false
                            }
                            .bold()
                        }
                    }
                }
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - 第二層：毛線材質清單
struct YarnMaterialList: View {
    @State private var showTips: Bool = false

    // 動畫狀態（按鈕）
    @State private var yarnButtonScale: CGFloat = 1.0
    @State private var yarnButtonGlow: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    // 以占位圖片名稱為主，若無資源會顯示占位方塊
    private let materials: [YarnMaterial] = [
        .init(
            name: "牛奶棉",
            imageName: "yarn_milk_cotton",
            description: "觸感柔軟、親膚，有一定光澤，保暖性中等。常見為棉與牛奶纖維或棉/腈綸混紡；分為四股、五股，股數影響粗細與手感。"
        ),
        .init(
            name: "情人棉",
            imageName: "yarn_lovers_cotton",
            description: "腈綸或棉腈混紡，柔軟順滑，光澤與垂感較佳，色彩鮮亮。"
        ),
        .init(
            name: "皮草線",
            imageName: "yarn_fur",
            description: "模仿動物皮毛效果，絨毛長短不一，質感蓬鬆柔軟，保暖佳。"
        ),
        .init(
            name: "蠶絲線",
            imageName: "yarn_silk",
            description: "強烈光澤、滑順親膚、透氣佳，輕盈且保暖性優於棉，耐磨略弱、價格較高。"
        ),
        .init(
            name: "馬海毛",
            imageName: "yarn_mohair",
            description: "極輕盈、蓬鬆保暖，具長絨毛與光澤，常與他纖混紡以提升強度。"
        ),
        .init(
            name: "金絲絨",
            imageName: "yarn_velvet_gold",
            description: "密集短絨、似天鵝絨觸感，可能含亮絲/亮片，柔軟且有垂感。"
        ),
        .init(
            name: "珊瑚絨",
            imageName: "yarn_coral_fleece",
            description: "極柔軟蓬鬆、毛圈細密、保暖好，但鉤織時針目較不清晰。"
        ),
        .init(
            name: "松鼠絨",
            imageName: "yarn_squirrel_fleece",
            description: "模仿松鼠毛，絨長適中，手感細膩順滑，毛感更柔軟自然。"
        ),
        .init(
            name: "亞麻/麻線",
            imageName: "yarn_linen",
            description: "纖維硬挺、透氣吸濕、天然清涼，成品具筋骨感，夏季適用。"
        )
    ]

    private var tipsText: String {
        """
        • 股數（如牛奶棉的四股、五股）：
         股數越多通常線材越粗，適合鉤織大型或較厚的作品；股數少則線材細，適合精細作品。

         • 鉤針選擇：
         線材越粗，通常需要搭配越粗的鉤針；反之亦然。您可以參考線材標籤上的建議鉤針尺寸。

         • 試鉤小樣：
         在開始正式作品前，建議先用線材試鉤一塊小樣片，以確定線材的手感、密度和最終尺寸是否符合預期。
        """
    }

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            List {
                Section("毛線不同的材質：") {
                    ForEach(materials) { material in
                        NavigationLink {
                            YarnMaterialShowcase(material: material)
                        } label: {
                            HStack {
                                Text(material.name)
                                    .font(.title3.weight(.semibold))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("毛線")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // 點擊動畫：放大回彈 + 短暫閃爍
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                            yarnButtonScale = 1.15
                            yarnButtonGlow = true
                        }
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7).delay(0.08)) {
                            yarnButtonScale = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                yarnButtonGlow = false
                            }
                        }
                        showTips = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.max.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(yarnButtonGlow ? .secondary : .yellow)
                        }
                        .padding(.horizontal, 4)
                        .scaleEffect(yarnButtonScale)
                    }
                    .accessibilityIdentifier("yarnTipsButton")
                }
            }
            .sheet(isPresented: $showTips) {
                ZStack {
                    AppBackground().ignoresSafeArea()
                    NavigationStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(tipsText)
                                    .font(.custom(introFontName, size: 18))
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .navigationTitle("小提示")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("完成") {
                                    showTips = false
                                }
                                .bold()
                            }
                        }
                    }
                    .toolbarBackground(.clear, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - 第三層：顯示該材質的圖片與說明（不再有下一頁）
struct YarnMaterialShowcase: View {
    let material: YarnMaterial

    // 新增：依材質名稱對應詳細規格
    private struct Spec {
        let gaugeRange: String           // 典型線徑範圍
        let recommendedHook: String      // 建議鉤針針號 (約 mm)
        let exampleUses: String          // 適用作品舉例
    }

    private var spec: Spec? {
        switch material.name {
        case "牛奶棉":
            return Spec(
                gaugeRange: "中細至中粗，依股數與品牌而異（約 2.0mm−4.0mm）",
                recommendedHook: "3.0mm−4.0mm\n（日規 5/0−7/0）",
                exampleUses: "嬰兒用品、玩偶、貼身衣物、圍巾、帽子、小件家居飾品。"
            )
        case "情人棉":
            return Spec(
                gaugeRange: "細至中細（約 1.75mm−3.0mm）",
                recommendedHook: "2.5mm−4.0mm\n（日規 4/0−7/0）",
                exampleUses: "夏季衣物、玩偶、披肩、手袋、家居飾品。"
            )
        case "皮草線":
            return Spec(
                gaugeRange: "特粗線（視絨毛密度，約 4.0mm 以上）",
                recommendedHook: "6.0mm−10.0mm\n（日規 10/0 以上）",
                exampleUses: "仿皮草外套、領子、帽子、圍巾、包包裝飾、玩偶毛髮。"
            )
        case "蠶絲線":
            return Spec(
                gaugeRange: "細至中細（純絲或混紡差異大，約 1.5mm−3.0mm）",
                recommendedHook: "2.0mm−4.0mm\n（日規 3/0−7/0）",
                exampleUses: "高檔絲巾、夏季衣物、貼身衣物、精緻小飾品。"
            )
        case "馬海毛":
            return Spec(
                gaugeRange: "極細至中細（常見蕾絲級 mohair 可雙股/混織）",
                recommendedHook: "3.0mm−6.0mm（視單股/合股）\n（日規 5/0−10/0）",
                exampleUses: "輕盈保暖的圍巾、披肩、毛衣、帽子；常與其他線材搭配營造毛茸茸效果。"
            )
        case "金絲絨":
            return Spec(
                gaugeRange: "中粗至粗（約 3.5mm−6.0mm）",
                recommendedHook: "4.0mm−6.0mm\n（日規 7/0−10/0）",
                exampleUses: "抱枕、毯子、保暖衣物、家居飾品、玩偶服裝。"
            )
        case "珊瑚絨":
            return Spec(
                gaugeRange: "粗至特粗（約 5.0mm 以上）",
                recommendedHook: "6.0mm−9.0mm\n（日規 10/0 以上）",
                exampleUses: "保暖毯子、睡袍、家居服、玩偶外層。"
            )
        case "松鼠絨":
            return Spec(
                gaugeRange: "中粗至粗（依品牌約 3.0mm−5.5mm）",
                recommendedHook: "4.0mm−6.0mm\n（日規 7/0−10/0）",
                exampleUses: "高級毛衣、外套、圍巾、帽子等講求細膩手感的保暖品。"
            )
        case "亞麻/麻線":
            return Spec(
                gaugeRange: "中細到中粗（約 1.5mm−3.5mm）",
                recommendedHook: "3.0mm−5.0mm\n（日規 5/0−8/0）",
                exampleUses: "夏季衣物、手袋、購物袋、餐墊、帽子、各種雜物籃/收納用品。"
            )
        default:
            return nil
        }
    }

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // 圖片（若找不到資源則顯示占位）
                    if let uiImage = UIImage(named: material.imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
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
                                    .font(.system(size: 36, weight: .regular))
                                    .foregroundStyle(.secondary)
                                Text("找不到圖片資源")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                        .frame(height: 220)
                    }

                    // 說明
                    Text(material.name)
                        .font(.largeTitle.bold())
                    Text(material.description)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    // 詳細規格區塊（保留）
                    if let spec {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top) {
                                Text("典型線徑範圍")
                                    .font(.headline)
                                    .frame(width: 100, alignment: .leading)
                                Text(spec.gaugeRange)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                            HStack(alignment: .top) {
                                Text("建議鉤針針號")
                                    .font(.headline)
                                    .frame(width: 100, alignment: .leading)
                                Text(spec.recommendedHook)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("作品舉例")
                                    .font(.headline)
                                Text(spec.exampleUses)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.top, 8)
                    }

                    Spacer(minLength: 0)
                }
                .padding()
            }
        }
        .navigationTitle(material.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - 第二層：棒針種類 + 尺寸規格表
struct NeedleTypeList: View {
    struct NeedleType: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let feature: String
        let usage: String
    }

    // 四種棒針種類（名稱 / 特徵 / 主要用途）
    private let types: [NeedleType] = [
        .init(
            name: "單頭棒針 (直針/單尖針)",
            imageName: "needle_straight",
            feature: "一端是針尖，另一端有擋頭（防止線圈滑出）。通常一組兩根使用。",
            usage: "適合平面編織，如：圍巾、毛衣前後片、毛毯等。"
        ),
        .init(
            name: "雙頭棒針 (兩頭尖針)",
            imageName: "needle_dpns",
            feature: "兩端都是針尖，中間沒有擋頭。通常一組四到五根使用。",
            usage: "適合小範圍的環狀編織，如：袖口、手套、襪子等。"
        ),
        .init(
            name: "輪針 (Circular Needles)",
            imageName: "needle_circular",
            feature: "兩根短棒針中間用一段軟線（多為塑膠）連接。",
            usage: "適用於大範圍的環狀編織（如毛衣身體、帽子）和大型平面編織（如大型毛毯）。是現代最常用的棒針類型。"
        ),
        .init(
            name: "麻花針 (Cable Needle)",
            imageName: "needle_cable",
            feature: "造型較短，多為彎曲或U形。",
            usage: "專門用於編織麻花（Cable）花樣時，暫時固定部分線圈。"
        )
    ]

    struct SpecRow: Identifiable {
        let id = UUID()
        let metric: String
        let us: String
        let jp: String
        let usage: String
    }

    private let specRows: [SpecRow] = [
        .init(metric: "2.0mm", us: "0",   jp: "0",   usage: "極細線 (如蕾絲線)"),
        .init(metric: "3.0mm", us: "2-3", jp: "3",   usage: "中細線"),
        .init(metric: "4.0mm", us: "6",   jp: "6-7", usage: "中粗線 (最常用於圍巾/毛衣)"),
        .init(metric: "5.5mm", us: "9",   jp: "11",  usage: "粗線"),
        .init(metric: "8.0mm", us: "11",  jp: "15",  usage: "超粗線 (極粗圍巾/毯子)")
    ]

    // 新增：補充按鈕的狀態與動畫
    @State private var showSupplement: Bool = false
    @State private var needleButtonScale: CGFloat = 1.0
    @State private var needleButtonGlow: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    private let supplementText: String = "棒針常見材質有木、竹、金屬。需配合毛線粗細選用合適尺寸"

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            List {
                // 棒針種類（第二層列表：僅顯示名稱，點進第三層看詳情）
                Section("棒針種類") {
                    ForEach(types) { type in
                        NavigationLink {
                            NeedleTypeDetail(type: type)
                        } label: {
                            HStack(spacing: 12) {
                                Text(type.name)
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.primary)
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 6)
                        }
                    }
                }

                // 尺寸與規格表（在第二層顯示）
                Section("尺寸與規格") {
                    // 表頭（US/JP 合併，無固定寬度，自然換行）
                    HStack(alignment: .top, spacing: 12) {
                        Text("公制直徑 (mm)")
                            .font(.headline)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Text("美/日號數 (US/JP)")
                            .font(.headline)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Text("適用線材 (參考)")
                            .font(.headline)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 4)

                    ForEach(specRows) { row in
                        HStack(alignment: .top, spacing: 12) {
                            Text(row.metric)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                            Text("\(row.us)/\(row.jp)")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                            Text(row.usage)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.body)
                        .foregroundStyle(.primary)
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("棒針")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // 點擊動畫：放大回彈 + 短暫閃爍（與前面一致）
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                            needleButtonScale = 1.15
                            needleButtonGlow = true
                        }
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7).delay(0.08)) {
                            needleButtonScale = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                needleButtonGlow = false
                            }
                        }
                        showSupplement = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.bubble.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(needleButtonGlow ? .secondary : .teal)
                        }
                        .padding(.horizontal, 4)
                        .scaleEffect(needleButtonScale)
                    }
                    .accessibilityIdentifier("needleSupplementButton")
                }
            }
            .sheet(isPresented: $showSupplement) {
                ZStack {
                    AppBackground().ignoresSafeArea()
                    NavigationStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(supplementText)
                                    .font(.custom(introFontName, size: 18))
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .navigationTitle("補充")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("完成") {
                                    showSupplement = false
                                }
                                .bold()
                            }
                        }
                    }
                    .toolbarBackground(.clear, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - 第三層：棒針種類詳細
struct NeedleTypeDetail: View {
    let type: NeedleTypeList.NeedleType
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            AppBackground().ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    if let uiImage = UIImage(named: type.imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 260)
                            .clipped()
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
                                Image(systemName: "pencil.and.outline")
                                    .font(.system(size: 36, weight: .regular))
                                    .foregroundStyle(.secondary)
                                Text("找不到圖片資源")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                        .frame(height: 220)
                    }

                    Text(type.name)
                        .font(.largeTitle.bold())
                    Text(type.feature)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(type.usage)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Spacer(minLength: 0)
                }
                .padding()
            }
        }
        .navigationTitle(type.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
