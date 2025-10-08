import SwiftUI
import SafariServices

private let introFontName = "ChenYuluoyan-2.0-Thin"

struct AdvancedView: View {
    struct Stitch: Identifiable {
        let id = UUID()
        let title: String
        let aliases: [String]
        let remoteURL: URL?
        let description: String
        let diagramImageName: String?
        let sampleImageName: String?
    }

    // 請將 remoteURL 與圖片資源名稱替換為實際資料（Assets 中的圖）
    private let advancedStitches: [Stitch] = [
        .init(
            title: "泡泡針/棗形針",
            aliases: ["Bobble Stitch"],
            remoteURL: URL(string: "https://youtu.be/L7zfo93Jx6g?si=rwC7Wzl2ofU0ir2D"),
            description: "將多個長針或中長針在同一針眼上織出，然後一次將所有有針眼收攏的立體編織技法，形成的紋理像一串小小的、圓潤的棗子或氣泡，立體感強，能為織物增添厚重感和裝飾性。",
            diagramImageName: "stitch_bobble",
            sampleImageName: "adv_bobble_sample"
        ),
        .init(
            title: "玉米花針",
            aliases: ["Popcorn Stitch"],
            remoteURL: URL(string: "https://youtu.be/KPXE6kJXcnc?si=XG8IuAJAAHiXmJfY"),
            description: "藉由在同一針目完成數針長針後，將第一針與最後一針引拔收合，形成更扎實、穩定的立體顆粒。與泡泡針不同，玉米花針通常需要把鉤子抽出再穿回第一針頭頂以引拔。",
            diagramImageName: "stitch_popcorn",
            sampleImageName: "adv_popcorn_sample"
        ),
        .init(
            title: "扇形針",
            aliases: ["Fan Stitch"],
            remoteURL: URL(string: "https://youtu.be/mZhHZKtx334?si=pTEiuj8iaLfQMnRD"),
            description: "扇形針由多針同高度的針法（如長針）在同一針目或同一空隙內展開，形成扇面。常見於蕾絲邊、披肩、毯子花樣。",
            diagramImageName: "stitch_fan",
            sampleImageName: "adv_fan_sample"
        ),
        .init(
            title: "貝殼針",
            aliases: ["Shell Stitch"],
            remoteURL: URL(string: "https://www.youtube.com/watch?v=rmBOcphmiPM&pp=ygUP6LKd5q686Yed5pWZ5a24"),
            description: "貝殼針與扇形針概念相近，多以奇數針（如 5 長針）在同一點展開並在兩側以短針固定，排列後呈現規則的貝殼紋。常見於披肩、披風與邊緣裝飾。",
            diagramImageName: "stitch_shell",
            sampleImageName: "adv_shell_sample"
        ),
        .init(
            title: "七寶針",
            aliases: ["Solomon's Knot"],
            remoteURL: URL(string: "https://youtu.be/yOizN3RN0r4?si=0t_ktqgFJWN06Bcd"),
            description: "七寶針為重複的環狀花樣，視圖解多由鎖針弧與長針組合形成交疊的圓弧紋理，外觀如七寶結。適合披肩、罩衫與鏤空圍巾。",
            diagramImageName: "stitch_seven_treasure",
            sampleImageName: "adv_shippo_sample"
        ),
        .init(
            title: "葉子針",
            aliases: ["Leaf Motif"],
            remoteURL: URL(string: "https://youtu.be/r0_kUpO5Ds0?si=YwxgSc1FrMpq58yU"),
            description: "葉子針透過長短針高度的漸變與加減針，勾出葉脈與葉緣的曲線。可單獨作為貼飾，或連續組合成蕾絲花樣。",
            diagramImageName: "stitch_leaf",
            sampleImageName: "adv_leaf_sample"
        )
    ]

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    Section {
                        ForEach(advancedStitches) { stitch in
                            NavigationLink {
                                StitchDetailView(
                                    title: stitch.titleWithAliases,
                                    bundleVideoName: nil,
                                    remoteURL: stitch.remoteURL,
                                    description: stitch.description,
                                    diagramImageName: stitch.diagramImageName,
                                    sampleImageName: stitch.sampleImageName,
                                    isAdvanced: true
                                )
                            } label: {
                                HStack {
                                    Text(stitch.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    } header: {
                        Text("進階針法")
                            .font(.title2.bold())
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 100)
                .background(AppBackground())
                .ignoresSafeArea()
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .navigationTitle("進階")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

private extension AdvancedView.Stitch {
    var titleWithAliases: String {
        guard !aliases.isEmpty else { return title }
        return "\(title)\n（\(aliases.joined(separator: "／"))）"
    }
}

#Preview {
    AdvancedView()
}
