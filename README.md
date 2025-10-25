# 鉤織入門指南

## 簡介
以 SwiftUI 打造的鉤織學習 App，提供從入門到進階的內容導覽。特色包含具儀式感的開場動畫、清晰的分頁導覽、視覺一致的卡片設計與基礎無障礙支援。專案聚焦在乾淨、可維護的檔案分層與元件化設計，便於持續擴充內容。

目標與價值
＊ 引導使用者入門鉤針編織
＊ 自上而下清楚的結構：首頁 Header、基礎針法專區、進階卡片與更多作品
＊ 元件化、可重用的卡片與小元件，降低開發成本並維持視覺一致性
＊ 支援深淺色模式與基礎無障礙標示
＊ ContentView.swift􀰓
   • 職責：App 主畫面容器。內含主 Scroll 區與底部工具列（BottomActionBar）。
   • 功能：
      • 回報捲動偏移（使用 ScrollOffsetPreferenceKey）。
      • 根據捲動與互動淡出/顯示底部工具列。
      • 可切換各主要分頁或錨點（若採單頁式則在此組裝各區塊）。
• HeaderView.swift
   • 職責：首頁頂部 Hero Header。
   • 功能：
      • 顯示標題、副標題與背景圖（可支援動態視差）。
      • 訂閱徽章（isSubscribed 狀態）顯示/隱藏。
      • 主題切換（@AppStorage("isDarkMode")）。
      • 可選：剪刀或品牌小動畫。
• BottomActionBar.swift
   • 職責：近似系統 TabBar 的底部工具列（不負責路由，只呈現選中狀態）。
   • 功能：
      • 顯示主要區段的快速入口（首頁、工具、基礎、進階、更多、商鋪）。
      • 依捲動或互動做透明度／位移動畫（與 ContentView 協作）。
• Components.swift
   • 職責：通用小元件。
   • 內容：
      • SectionHeader：區段標題與說明。
      • ToolBarQuickInfo：工具列上的小資訊（如當前章節或提示）。
      • ToolChip：小型工具/標籤按鈕。
      • TipBubble：提示泡泡，支援箭頭方向與強調色。
• Cards.swift
   • 職責：視覺卡片與容器元件。
   • 內容：
      • GlassCardBackground：毛玻璃風格背景（Material/blur + overlay 線條）。
      • GlassPill：膠囊樣式容器，適合徽章與狀態。
      • ImageCaptionCard：上圖下文卡片。
      • StitchCard：針法卡（縮圖、標題、難度徽章）。
      • StitchWideCard：寬版橫向卡（適合橫圖、橫向內容）。
      • DifficultyBadge：難度徽章（Beginner/Intermediate/Advanced）。
• StitchTallCard.swift
   • 職責：進階針法直式卡片。
   • 功能：
      • 上圖下文佈局，支援單或多影片（VideoItem）。
      • 可顯示難度、標籤、收藏按鈕。
• FoundationStitchesSection.swift
   • 職責：入門四法專區。
   • 功能：
      • 區段介紹文字與導覽。
      • 影片連結清單（VideoItem），並在缺資源時提供 fallback 顯示。
      • 可嵌 BasicStitchSubsection 作為子內容。
• BasicStitchSubsection.swift
   • 職責：基礎針法子區塊。
   • 功能：
      • 標題、簡介、步驟圖（GalleryItem）、教學影片（VideoItem）、作品範例。
      • 可選圖文卡片（ImageCaptionCard / StitchCard）以強化理解。
• Utilities.swift
   • 職責：共用工具。
   • 內容：
      • ScrollOffsetPreferenceKey：回報 ScrollView 垂直偏移給 ContentView。
      • BackgroundGradient：背景漸層或動態背景工具。
• Models.swift
   • 職責：資料模型。
   • 內容：
      • GalleryItem：圖片或媒體資料（id、imageName/url、caption）。
      • StitchDetail：針法細節（id、title、summary、difficulty、steps、gallery、videos）。
      • VideoItem：教學影片（id、title、url/assetName、duration/thumbnail）。
• HomeView.swift􀰓（若保留）
   • 職責：首頁內容與開場動畫（雲幕簾 Splash、Carousel、Outro）。
   • 備註：若採 ContentView 為入口並整合底部工具列，可將 HomeView 作為其中一個分頁或主區段。

檔案間關聯
• ContentView
   • 讀取 ScrollOffsetPreferenceKey，決定 BottomActionBar 的顯示/淡出。
   • 組合 HeaderView、FoundationStitchesSection、進階卡片等區塊。
• HeaderView
   • 綁定 @AppStorage("isDarkMode") 與 isSubscribed 狀態（可由 ContentView 注入）。
• FoundationStitchesSection
   • 使用 Models 中的 StitchDetail、VideoItem，內嵌 BasicStitchSubsection。
• BasicStitchSubsection
   • 渲染 GalleryItem（步驟圖、範例）與 VideoItem（教學影片）。
• StitchTallCard / Cards / Components
   • 作為視覺積木被各區段重用。
• Utilities
   • 為 Scroll 偏移與背景提供共用工具。
