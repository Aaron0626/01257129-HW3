# 鉤織入門指南
<img width="583" height="543" alt="image" src="https://github.com/user-attachments/assets/66c2d658-a2fb-420c-bfbd-29692c938b6f" />

## 簡介
以 SwiftUI 打造的鉤織學習 App，提供從入門到進階的內容導覽。特色包含具儀式感的開場動畫、清晰的分頁導覽、視覺一致的卡片設計與基礎無障礙支援。專案聚焦在乾淨、可維護的檔案分層與元件化設計，便於持續擴充內容。

## 目標與價值
* 引導使用者入門鉤針編織
* 自上而下清楚的結構：首頁 Header、基礎針法專區、進階卡片與更多作品
* 元件化、可重用的卡片與小元件，降低開發成本並維持視覺一致性
* 支援深淺色模式與基礎無障礙標示
  
## 程式架構  
* AdvancedView.swift
   * 功能：進階針法頁面。
      * 與 FoundationView 對應，這個畫面用來展示更複雜的針法或技巧，點擊後會藉由NavigationStack、NavigationLink跳到另一個頁面顯示該針法的名稱、圖解、文字說明和影片連結
* AppBackground.swift
   * 功能：背景顏色。
      * 每個頁面的顏色都由這邊設定，設有白天模式與夜晚模式
* Card.swift
   * 功能：定義一些通用的卡片元件。
      * 用來在 FoundationView 或 AdvancedView 中顯示單一針法預覽的基礎卡片樣式
* ContentView.swift
   * 功能：App 的主入口
     * 使用TabView用來切換 HomeView、ToolView、FoundationView、AdvancedView、ShopView 和 MoreView
* FlipCard.swift
   * 功能：一個特殊的卡片元件，具有「翻轉」動畫效果。
      * 使用在工具頁面中的其他，右上角有個可以切換圖片的按鈕
* FoundationView.swift
   * 功能：基礎針法頁面。
      * 專門用來列表或展示入門/基礎鉤織針法（如鎖針、短針等）的畫面，點擊後會藉由NavigationStack、NavigationLink跳到另一個頁面顯示該針法的名稱、圖解、文字說明和影片連結
* GalleryData.swift
   * 功能：更多作品頁面的圖片牆的資訊內容。
      * 有分不同類，每張圖片點開會有完整的圖片以及詳細的文字圖解或是圖片圖解
* HeaderView.swift
   * 功能：一個可重用的「標頭」元件。
      * 但目前只用在首頁標題上，顯示頁面標題、背景圖、還有一些控制按鈕（例如切換深淺色模式）
* HomeView.swift
   * 功能：App 的「首頁」畫面。
      * 有HeaderView的頁面標題、使用TabView可水平滑動觀看成品展示、鼓勵新手的結語(組合多種文字樣式)
* MoreView.swift
   * 功能：更多作品頁面。
      * 從 GalleryData 讀取已分類的作品集，將它們顯示在一個可自適應的網格 (Grid) 中。使用者可以點擊任何一個作品來彈出一個詳情視窗 (DetailSheet)，查看大圖和對應的「圖解」
* ShopView.swift
   * 功能：進階針法頁面。
      * 更多作品頁面的圖片牆的設定
* StitchDetailView.swift
   * 功能：「針法詳情」畫面
        * 當使用者在 FoundationView 或 AdvancedView 點擊某一個針法時，會導航到這個畫面。它會顯示該針法的詳細步驟、教學影片、圖庫等
* Tool.swift
   * 功能：工具頁面的詳細內容。
      * 用來展示「鉤針」、「棒針」、「毛線」和「其他」工具的詳細資訊
ToolView.swift
   * 功能：工具頁面。
      * 開始鉤織前需要準備哪些東西，這些物品的相關介紹(毛線的種類、鉤針的尺寸等)
