//
//  FoundationView.swift
//  01257129-HW3
//
//  Created by user10 on 2025/10/22.
//

import SwiftUI
import AVKit
private let introFontName = "ChenYuluoyan-2.0-Thin"

struct FoundationView: View {
    private struct Stitch: Identifiable {
        let id = UUID()
        let title: String
        let bundleVideoName: String?
        let remoteURL: URL?          // direct streamable URL (mp4/mov/m4v 或 YouTube)
        let description: String
        // 新增：圖解與樣本圖片名稱
        let diagramImageName: String?
        let sampleImageName: String?
    }

    // 入門四針（保留現有資料，補齊新欄位為 nil）
    private let stitches: [Stitch] = [
        .init(
            title: "起立針",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://youtu.be/WpeC5peABBw?si=jDkesSxI5fl6RFtm")!,
            description: "起立針用於開始新一圈或新一行，調整線高使下一個針目高度一致。常見做法為在行首先鉤 1–3 鎖針作為起立針，依後續針法高度而定。",
            diagramImageName: nil,
            sampleImageName: nil
        ),
        .init(
            title: "鎖針",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://youtu.be/mw1D2in11Mw?si=jzXcPv8snY-TeMLN"),
            description: "鎖針（ch）是最基礎的起針方式，用於建立起針鍊或作為花樣間的過渡。針法要領：保持線張力一致，勾線拉出後立刻輕收回到均勻大小。",
            diagramImageName: nil,
            sampleImageName: nil
        ),
        .init(
            title: "環形起針",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://youtu.be/zS2b27O7pc4?si=wONxh6EkgYbaZwaF"),
            description: "環形起針常用於編織圓形或玩偶，先在手指上繞一圈形成可拉緊的環，再在環上鉤出指定針數，最後拉緊起始尾線以收合中心。",
            diagramImageName: nil,
            sampleImageName: "sample1"
        ),
        .init(
            title: "引拔針",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://youtu.be/LyyDQeCVwfY?si=MiNR6KqUHAbg282O"),
            description: "引拔針（sl st）用於連接或位移，不增加高度。將針穿入目標針目，勾線一次性拉過兩個線圈即可。常見於收尾、合併圈首尾。",
            diagramImageName: nil,
            sampleImageName: nil
        )
    ]

    // 使用占位圖片名稱與示範連結，請替換為實際資源
    private let basicStitches: [Stitch] = [
        .init(
            title: "短針（X）",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=11s"),
            description: "織物最密實、最堅固，針目最小。常用於玩偶、包包等，也適合用於織物邊緣的收尾。\n\n起立鎖針：\n每行開始時通常勾 1 針鎖針作為起立針。",
            diagramImageName: "stitch_sc_step",
            sampleImageName: "sc_sample"
        ),
        .init(
            title: "中長針（T）",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=158s"),
            description: "介於短針和長針之間，能創造出比短針更具彈性的織紋，編織速度快、質地柔軟，是許多衣物與毯子的好選擇。\n\n起立鎖針： \n每行開始時通常勾 2 針鎖針作為起立針。",
            diagramImageName: "stitch_hdc_step",
            sampleImageName: "hdc_sample"
        ),
        .init(
            title: "長針（F）",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=329s"),
            description: "織出的針目較高，比短針的速度更快、透氣性佳，常見於披肩、圍巾與開放式花樣。\n\n起立鎖針： \n每行開始時通常勾 3 針鎖針作為起立針。",
            diagramImageName: "stitch_dc_step",
            sampleImageName: "dc_sample"
        ),
        .init(
            title: "長長針（E）",
            bundleVideoName: nil,
            remoteURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=541s"),
            description: "織出的針目更高，能快速完成大面積的織物、堆疊高度，常用於華麗花樣與鏤空設計。\n\n起立鎖針： \n每行開始時通常勾 4 針鎖針 (ch 4) 作為起立針。",
            diagramImageName: "stitch_tr_step",
            sampleImageName: "tr_sample"
        )
    ]

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {

                        // 入門四針（單欄列）
                        Section() {
                            VStack(spacing: 0) {
                                ForEach(stitches) { stitch in
                                    NavigationLink {
                                        StitchDetailView(
                                            title: stitch.title,
                                            bundleVideoName: stitch.bundleVideoName,
                                            remoteURL: stitch.remoteURL,
                                            description: stitch.description,
                                            diagramImageName: stitch.diagramImageName,
                                            sampleImageName: stitch.sampleImageName
                                        )
                                    } label: {
                                        HStack {
                                            Text(stitch.title)
                                                .font(.headline)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 14)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)

                                    Divider().padding(.leading)
                                }
                            }
                            .background(.background)
                        } header: {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.background)
                                    .opacity(0.98)
                                    .ignoresSafeArea()
                                Text("入門四針")
                                    .font(.title2.bold())
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        // 基礎針法（單欄列）
                        Section {
                            VStack(spacing: 0) {
                                ForEach(basicStitches) { stitch in
                                    NavigationLink {
                                        StitchDetailView(
                                            title: stitch.title,
                                            bundleVideoName: stitch.bundleVideoName,
                                            remoteURL: stitch.remoteURL,
                                            description: stitch.description,
                                            diagramImageName: stitch.diagramImageName,
                                            sampleImageName: stitch.sampleImageName
                                        )
                                    } label: {
                                        HStack {
                                            Text(stitch.title)
                                                .font(.headline)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 14)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)

                                    Divider().padding(.leading)
                                }
                            }
                            .background(.background)
                        } header: {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.background)
                                    .opacity(0.98)
                                    .ignoresSafeArea()
                                Text("基礎針法")
                                    .font(.title2.bold())
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.top, 100)
                .background(AppBackground())
                .ignoresSafeArea()
                .scrollContentBackground(.hidden)
                .navigationTitle("基礎")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    FoundationView()
}
