import Foundation

enum Diagram: Equatable, Hashable {
    case text(String)
    case image(String)
    case images([String]) // 支援多張圖解
}

struct GalleryItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let diagram: Diagram

    init(imageName: String, title: String? = nil, diagram: Diagram) {
        self.imageName = imageName
        self.title = title ?? imageName
        self.diagram = diagram
    }
}

enum GalleryCategory: String, CaseIterable, Identifiable {
    case genshin = "原神"
    case plant = "植物"
    case animal = "動物"
    case bag = "包包"
    case clothing = "衣物"
    case other = "其他"

    var id: String { rawValue }
}

enum GalleryData {

    static let data: [GalleryCategory: [GalleryItem]] = {

        // 原神（1...6）
        let genshin: [GalleryItem] = [
            // TODO: 補上正確 title 與圖解（單張或多張）
            GalleryItem(imageName: "genshin1", title: "原石", diagram: .images(["genshin1_d1", "genshin1_d2"])),
            GalleryItem(imageName: "genshin2", title: "魈鳥", diagram: .image("genshin2_d")), // 例：單張圖解
            GalleryItem(imageName: "genshin3", title: "月之輪 • 雷", diagram: .images(["genshin3_d1", "genshin3_d2", "genshin3_d3"])), // 例：多張圖解
            GalleryItem(imageName: "genshin4", title: "原神 4", diagram: .image("genshin4_d")),
            GalleryItem(imageName: "genshin5", title: "小小史萊姆", diagram: .images(["genshin5_d1", "genshin5_d2", "genshin5_d3"])),
            GalleryItem(imageName: "genshin6", title: "原神 6", diagram: .images(["genshin6_d1", "genshin6_d2", "genshin6_d3", "genshin6_d4", "genshin6_d5", "genshin6_d6", "genshin6_d7"]))
        ]

        // 植物（1...6）
        let plant: [GalleryItem] = [
            GalleryItem(imageName: "plant1", title: "彼岸花", diagram: .image("plant1_d")),
            GalleryItem(imageName: "plant2", title: "小蘑菇", diagram: .image("plant2_d")),
            GalleryItem(
                imageName: "plant3",
                title: "白菜",
                diagram: .text("""
                微鉤白菜的圖解：
                白菜葉
                - R1：起 13 鎖針，倒數第 2 針起回鉤，11 短針，W，10 短針，加針。
                - R2：加針，3 短針，7 短針，3 次加針，7 短針，3 短針，2 次加針。
                - R3：短針，加針，3 短針，2 短針，2 中長針，3 長針，3 組（長針加針 FV，FW），3 長針，2 中長針，2 短針，3 短針，2 組（短針、加針）。
                - R4：從第 3 圈綠色針目的第 5 針開始鉤，引拔針，（短針，3 鎖針）重複至倒數第 5 針，引拔結束。

                白菜心
                - R1：白色線環形起針 6 短針。
                - R2：6 次加針。
                - R3：（短針，加針）×6。
                - R4：（2 短針，加針）×6，與葉子連接同鉤，將 3 片葉子平均連在菜心周圍，每片葉子選取中間 6 針連接。
                - R5–R7：24 短針。
                - R8–R17：換綠色線，24 短針。
                - R18：內半針（2 短針，減針）×6。
                - R19：內半針（短針，減針）×6。
                - R20：6 次減針。
                - 菜心葉子：鉤在第 18–19 行的外半針上，（短針，3 鎖針）持續重複。完成後，3 片葉子可用熱熔膠黏上或用線直接縫合。
                """)
            ),
            GalleryItem(
                imageName: "plant4",
                title: "芍藥花",
                diagram: .text("""
                鉤織芍藥花（附圖解）

                花心
                - R1：環形起針 5 短針。
                - R2：5 次加針。
                - R3：5 組（短針、加針）。

                花瓣
                - R7：3 鎖針，［（三卷長針 E，三卷長針），（三卷長針，狗牙拉針，三卷長針），2×（2 個三卷長針，狗牙拉針），（三卷長針，三卷長針 E，3 鎖針，引拔針）］，下一針引拔針，然後同針目重複，共 5 次。
                - R8：3 鎖針，在上一圈花瓣中間位置入針，引拔，3 鎖針，［三卷長針 E，（2 個三卷長針，狗牙拉針），（2 個三卷長針），（三卷長針，狗牙拉針，三卷長針），（三卷長針，三卷長針 E，3 鎖針，引拔針）］，5 個針目為一組，重複 5 次。
                - R9：3 鎖針，在上一圈花瓣中間位置入針，引拔，3 鎖針，［（三卷長針 E，三卷長針，狗牙拉針），2×（2 個三卷長針），（狗牙拉針，三卷長針，三卷長針 E，3 鎖針，引拔針）］，4 個針目為一組，重複 5 次。
                - R10：3 鎖針，在上一圈花瓣中間位置入針，引拔，3 鎖針，［三卷長針 E，（三卷長針，狗牙拉針，三卷長針），（2 個三卷長針，狗牙拉針），（三卷長針 E，3 鎖針，引拔針）］，重複 3 次。

                花托
                環形起針，起立 7 鎖針，倒數第 2 針起鉤 引拔針、4 短針、中長針，圈內引拔，重複 5 次。

                葉子
                - 葉片 1：13 鎖針，倒數第 2 針起回鉤，引拔針、中長針、長針、5 次三卷長針、長針、中長針、引拔針，不斷線繼續鉤葉片 2。
                - 葉片 2：12 鎖針，倒數第 2 針起回鉤，引拔針、中長針、長針、3 次三卷長針、長針、中長針、引拔針。
                - 葉片 3：11 鎖針，倒數第 2 針起回鉤，引拔針、中長針、長針、4 次三卷長針、長針、中長針、引拔針。
                - 葉片 4：12 鎖針，倒數第 2 針起回鉤，引拔針、中長針、長針、3 次三卷長針、長針、中長針、引拔針。
                - 葉片 5：在葉片 1 和葉片 2 中間的 2 針鎖針上鉤 2 針引拔，12 鎖針，倒數第 2 針起回鉤，引拔針、中長針、長針、5 次三卷長針、長針、中長針、引拔針，在整個葉片編織起點引拔收尾。
                """)
            ),
            GalleryItem(imageName: "plant5", title: "多肉植物", diagram: .images(["plant5_d1", "plant5_d2"])),
            GalleryItem(imageName: "plant6", title: "蕨類", diagram: .images(["plant6_d1", "plant6_d2"]))
        ]

        // 動物（1...6）
        let animal: [GalleryItem] = [
            // 例：animal1 使用長文字圖解
            GalleryItem(imageName: "animal1", title: "鈎織小蛇", diagram: .text("""
            材料準備：
                • 各色毛線（依您想要的小蛇顏色選擇），操作時可不斷線換行鉤織。
                • 鉤針、剪刀、填充棉（若需要讓小蛇更飽滿）、黑色繡線（用於繡眼睛）或成品玩偶眼睛。

            頭部：
                1. 環形起針，在圈內鉤 6 針短針，拉緊線頭，與第一針引拔連接。
                2. 第 2 圈：[1 短針、1 加針] × 3。
                3. 第 3 圈：1 加針、3 短針、1 加針、4 短針。
                4. 第 4 圈：2 加針、3 短針、2 加針、4 短針。
                5. 第 5–6 圈：各 15 針短針。
                6. 第 7 圈：2 減針、2 短針、2 減針、4 短針。
                7. 第 8 圈：1 減針、3 短針、1 減針、4 短針。
                8. 第 9 圈：[1 短針、1 減針] 重複 3 組。
                9. 第 10 圈：6 針短針。
                （身體部分長度可自行調整）

            裝飾：
                • 以黑色繡線繡出小蛇眼睛，或以熱熔膠將成品玩偶眼睛黏貼於頭部合適位置。

            填充：
                • 在頭部與身體內填入適量的填充棉。
            """)),
            // 例：animal2 單張圖解
            GalleryItem(imageName: "animal2", title: "一團小貓", diagram: .image("animal2_d")),
            GalleryItem(imageName: "animal3", title: "鈎織小貓", diagram: .images(["animal3_d1", "animal3_d2", "animal3_d3", "animal3_d4"])),
            GalleryItem(
                imageName: "animal4",
                title: "小山雀",
                diagram: .text("""
                鉤織小山雀（附圖解）
                胖乎乎的小山雀 🐦🐦🐦

                環形起針
                - R1：7 短針 
                - R2：7 次加針 
                - R3：（加針，3 短針）×3，加針，短針 
                - R4–R5：18 短針 
                - R6：2 次加針，（短針，3 次加針）×4 

                嘴巴部分：取棕色線鉤 2 鎖針後斷線，在 R4 的第 9、10 針入針。
                - R7：加針，30 短針，加針 
                - R8：加針，32 短針，加針 
                - R9：加針，34 短針，加針 
                - R10：2 鎖針起立，長針減針（FA），中長針減針（TA），減針（A），26 短針，減針（A），中長針減針（TA），長針減針（FA） 

                尾巴：7 鎖針，倒數第 3 針起鉤 中長針、短針、3 針引拔，斷線。
                在 R9 的第一針與最後一針入針，將尾巴縫入。

                - R11：（短針，減針，短針）×8 
                - R12：（短針，減針）×8 塞棉
                - R13：中長針減針（TA）×8 
                斷線，藏線。

                翅膀 ×2（片鉤，起針留長線以便縫合）
                1：5 鎖針，倒數第 2 針起鉤，3 短針，加針，換線 
                2：1 鎖針，4 短針，加針，換線 
                3：1 鎖針，6 短針 
                4：1 鎖針，空 1 針，4 短針，（中長針、長針加針 FV），1 鎖針 斷線留長線。

                縫合建議：左翼從嘴巴左側數第 5 針（可依感覺微調）下方一行的對應位置入針縫合；右翼同理。
                """)
            ),
            GalleryItem(imageName: "animal5", title: "章魚翻翻樂", diagram: .image("animal5_d")),
            GalleryItem(imageName: "animal6", title: "貓爪", diagram: .text("""
                猫爪
                - 材料：白色和粉色毛線、3mm鉤針。
                - 主體（鉤两片）：
                - R1：粉線環起，(枣形针Q,1CH)*8。
                - R2：換白線，(Q,1CH)*16。
                - R3：換粉線，((Q,1CH,Q,1CH,Q,1CH,1SL),K2)*4。
                - R4：换白線，從第一个肉垫那里鉤(2X,2V,2X,上一圈引拔針那裡鉤X)*4,5X,(V,2X)*2,V,5X。
                - 最後挑每片的外半針，鉤一圈引拔針。
                - 掛绳：白線鎖起14針鎖針。
                蝴蝶
                - 材料：彩色毛線、3mm鉤針。
                - 第一圈：環形起针，先鎖3針（相當於1個長針），再鉤2個長針，鉤完起2个鎖針，此為一组。按此方法共鉤8组，最後在開頭第三個鎖針上引拔，斷線，拉緊線圈。
                - 第二圈：在第一圈的缝隙處鉤，先鎖3針作爲1个長針，再鉤2個長針，然後鉤2個鎖針，繼續鉤3个長針，都在同一个缝隙鉤，為一组。共鉤8组，完成後在開頭第3个鎖針上引拔，斷線。
                - 第三圈：在大缝隙處鉤，起3个鎖針作為1個長針，再鉤2個長針，然後起3個鎖針鉤狗牙针，繼續鉤3個長針。鉤完起2個鎖針，在兩個大缝隙中鉤一個短針，再起2個鎖針，為一组，共鉤8组。最後在開頭第3個鎖針上引拔，斷線。
                - 觸角：起8個鎖針，倒數第2個針目回鉤引拔针，一共鉤7個。鉤完再起8個鎖針，繼續倒2回鉤7個引拔针，鉤完在第一針鎖針引拔，斷線，剪掉短線。將蝴蝶主體對折，觸角穿針缝合即可。
                """))
        ]

        // 包包（1...6）
        let bag: [GalleryItem] = [
            GalleryItem(imageName: "bag1", title: "Prada包", diagram: .image("bag1_d")),
            GalleryItem(imageName: "bag2", title: "麥穗包", diagram: .image("bag2_d")),
            GalleryItem(imageName: "bag3", title: "秋冬絞花包", diagram: .image("bag3_d")),
            GalleryItem(imageName: "bag4", title: "零錢包", diagram: .text("""
                包底：兩種鉤法
                第一種，長方形，起針23個鎖針，倒二鉤22個短針，往返3行後，鉤一圈短針，在4個角各加1針即可
                想做大點的，起針加針就行，包底加行數
                第二種，橢圓形，起針21個鎖針，二鉤19個短針，1W，18個短針，1V；第二圈，鉤1V,18X,3V,18X,2V;
                第三圈，鉤1(VX),18X,3(VX),18X,2(VX)即可
                做大起針加針，包底加圈數，規律一樣
                    
                包身花紋：
                挑外半針鉤一圈不加不減短針，再正常鉤3圈短針
                第5圈開始花紋，鉤的是1個長針減針1個鎖針，一直重複即可，長針減針入針位置中間空一針
                """)),
            GalleryItem(imageName: "bag5", title: "几何立体托特中性钩织包", diagram: .text("""
                一、材料準備
                • 鉤針：4.0mm鉤針）。
                • 線材：本體可選用中粗棉線，口袋內外選用細線
                • 輔料：拉鍊磁吸扣1對
                二、各模組鉤織細節
                1. 包身正面-上左右長方形（共2片）
                起針15短針，往返鉤織18行（每行15短針），完成後得到長18針、寬15行的長方形。
                2. 包身正面-下左右梯形（共2片）
                • 第1行：起9短針。
                • 第2行：兩端各加1針，共11短針。
                • 第3行：兩端各加1針，共13短針。
                • ……以此類推，每行遞增2針，鉤至第11行。
                3. 包身正面-口袋內側（1片）
                用細線鉤織：
                • 第1行：起針「1短針 + 3短針」（共4短針）。
                • 第2行：兩端各加1針，共6短針。
                • 第3行：兩端各加1針，共8短針。
                • ……每行遞增2針，鉤至第19行，針數為 4 + (19 - 1)×2 = 40 短針（此處需注意：後續「每行43針」可能是計算或表述誤差，實際需以最終尺寸匹配為準，若按遞增邏輯，以滿足起針數或遞增規則的規定遞增規則）。
                • 接著不加不減鉤30行，每行保持43針（若前序針數不足，可在遞增階段調整至43針後再開始不加不減行）。
                • 包身正面-口袋外側（1片）
                鉤織方法與口袋內側完全一致：先用細線按「每行多2針」的規律鉤19行，再不加不減鉤18行（每行43針）。
                三、組裝與縫合
                1. 口袋組裝
                將口袋內側與外側對齊，邊緣用鎖針按圖片中口袋的形狀和縫合樣式鉤織縫合；在口袋開口處安裝拉鍊，拉鍊邊緣用鎖針收邊
                2. 包身正面拼接
                將「上長方形」與「下梯形」依圖中包身的幾何拼接方式對齊，並用鎖針縫合，形成完整的包身正面。
                3. 包身背面製作
                完全重複「包身正面」的所有鉤織與拼接步驟，得到包身背面。
                4. 包包整體縫合
                • 將包身正面與背部邊緣對齊，拼接處以鎖針收邊縫合。
                • 縫合提前鉤好的包帶固定在包身兩側。
                • 包口處鉤1圈鎖針收口；在包口內側對應位置縫合磁吸扣，完成製作。
                """)),
            GalleryItem(imageName: "bag6", title: "波浪紋包包", diagram: .images(["bag6_d1", "bag6_d2"]))
        ]

        // 衣物（1...6）
        let clothing: [GalleryItem] = [
            GalleryItem(imageName: "clothing1", title: "楓葉披肩", diagram: .image("clothing1_d")),
            GalleryItem(imageName: "clothing2", title: "光遇披肩", diagram: .images(["clothing2_d1", "clothing2_d2"])),
            GalleryItem(imageName: "clothing3", title: "七星斗篷", diagram: .image("clothing3_d")),
            GalleryItem(imageName: "clothing4", title: "六邊形開衫", diagram: .images(["clothing4_d1", "clothing4_d2", "clothing4_d3", "clothing4_d4", "clothing4_d5"]))
        ]

        // 其他（1...6）
        let other: [GalleryItem] = [
            GalleryItem(imageName: "other1", title: "羽毛球拍掛件鈎織", diagram: .image("other1_d")),
            GalleryItem(imageName: "other2", title: "打工牛馬人", diagram: .image("other2_d")),
            GalleryItem(imageName: "other3", title: "杯墊", diagram: .image("other3_d")),
            GalleryItem(imageName: "other4", title: "金元寶", diagram: .image("other4_d")),
            GalleryItem(imageName: "other5", title: "人偶", diagram: .images(["other5_d1", "other5_d2", "other5_d3"])),
            GalleryItem(imageName: "other6", title: "小幽靈", diagram: .image("other6_d"))
        ]

        // 彙整成字典
        let dict: [GalleryCategory: [GalleryItem]] = [
            .genshin: genshin,
            .plant: plant,
            .animal: animal,
            .bag: bag,
            .clothing: clothing,
            .other: other
        ]

        return dict
    }()
}
