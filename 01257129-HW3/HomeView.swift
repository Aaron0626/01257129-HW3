import SwiftUI

private let introFontName = "ChenYuluoyan-2.0-Thin"

struct HomeView: View {
    // Nested Tool type to satisfy references from Tool.swift and ToolView.swift
    struct Tool: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let symbol: String
    }

    // MARK: - Splash Phases
    private enum SplashPhase: Equatable {
        case covering          // two big clouds covering screen
        case progress          // auto progress running
        case awaitTap          // finished progress, wait for tap
        case revealing         // clouds sliding away
        case revealed          // main content visible
    }

    @State private var phase: SplashPhase = .covering
    @State private var progress: Double = 0.0
    @State private var isSpinning: Bool = false
    @State private var allowTapToReveal: Bool = false

    // Curtain offsets (0 = closed, negative = slide up, positive = slide down)
    @State private var topOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0

    // HeaderView 綁定狀態
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var animateScissors: Bool = false
    @State private var isSubscribed: Bool = false

    // Animation tuning
    private let revealDuration: Double = 0.9

    var body: some View {
        ZStack {
            // Background behind everything
            AppBackground()
                .ignoresSafeArea()

            // Main content (hidden until revealed)
            mainContent
                .opacity(phase == .revealed ? 1 : 0)
                .allowsHitTesting(phase == .revealed)

            // Splash overlay (covers screen until reveal)
            if phase != .revealed {
                splashOverlay
                    .transition(.opacity)
                    .onAppear {
                        startSplashFlow()
                    }
            }
        }
    }

    // MARK: - Main Content Shown After Reveal
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HeaderView(
                    title: "鉤織入門指南",
                    subtitle: "從入門到熟練，輕鬆學會鉤針針法",
                    bgImageName: "crochet_hero",
                    isDarkMode: $isDarkMode,
                    animateScissors: $animateScissors,
                    isSubscribed: $isSubscribed
                )
                .frame(maxWidth: 900)
                .padding(.horizontal)
                .padding(.top, 24)

                // 中段圖片輪播：Image0 ~ Image3
                carousel

                // 結語段落
                outro
                    .frame(maxWidth: 900, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    // MARK: - Carousel
    private var carousel: some View {
        VStack(alignment: .leading, spacing: 12) {
            TabView {
                ForEach(0..<4, id: \.self) { idx in
                    let name = "Image \(idx)"
                    Group {
                        if let ui = UIImage(named: name) {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.secondary.opacity(0.1))
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.secondary)
                                    Text("找不到圖片：\(name)")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 240)
        }
    }

    // MARK: - Outro
    private var outro: some View {
        VStack(alignment: .leading, spacing: 14) {
            // 開始你的鉤織旅程吧！（“鉤織”字體大一點粗體）
            Group {
                Text("開始你的")
                    .font(.custom(introFontName, size: 30))
                +
                Text("鉤織")
                    .font(.custom(introFontName, size: 35).bold())
                    .foregroundStyle(Color.cyan)
                +
                Text("旅程吧！")
                    .font(.custom(introFontName, size: 30))
            }
            .foregroundStyle(.primary)

            // 從基礎練習開始...（“基礎”“進步”字體大一點粗體）
            Group{
                Text("從")
                    .font(.custom(introFontName, size: 20))
                +
                Text("基礎")
                    .font(.custom(introFontName, size: 25).bold())
                +
                Text("練習開始，慢慢建立肌肉記憶，別害怕拆掉重來，每一針都會讓你更")
                    .font(.custom(introFontName, size: 20))
                +
                Text("進步")
                    .font(.custom(introFontName, size: 25).bold())
                +
                Text("！")
                    .font(.custom(introFontName, size: 20))
            }
            .foregroundStyle(.secondary)

            // 祝編織愉快～（靛色粗體）
            Text("祝編織愉快～")
                .font(.custom(introFontName, size: 30).bold())
                .foregroundStyle(Color.indigo)
        }
        .multilineTextAlignment(.leading)
    }

    // MARK: - Splash Overlay
    private var splashOverlay: some View {
        GeometryReader { geo in
            ZStack {
                // Two big cloud curtains (one big cloud each)
                TopCloudCurtain()
                    .offset(y: topOffset)
                    .frame(height: min(geo.size.height * 0.65, 520), alignment: .bottom)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(edges: .top)

                BottomCloudCurtain()
                    .offset(y: bottomOffset)
                    .frame(height: min(geo.size.height * 0.65, 520), alignment: .top)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(edges: .bottom)

                // Center stack: gear + progress + hint
                VStack(spacing: 12) {
                    // Rotating gear
                    Image(systemName: "gearshape")
                        .font(.system(size: 44, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .rotationEffect(.degrees(isSpinning ? 360 : 0))
                        .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isSpinning)
                        .onAppear { isSpinning = true }
                        .onDisappear { isSpinning = false }

                    // Progress
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                        .tint(.blue)
                        .padding(.horizontal, 48)
                        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)

                    // Tap hint (only after progress completes)
                    if phase == .awaitTap {
                        Text("點一下繼續")
                            .font(.custom(introFontName, size: 20).bold())
                            .foregroundStyle(.blue)
                            .padding(.top, 4)
                            .transition(.opacity)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .frame(maxWidth: 520)
                .contentShape(Rectangle())
                .onTapGesture {
                    if allowTapToReveal && (phase == .awaitTap || phase == .progress) {
                        revealClouds(geo: geo)
                    }
                }
            }
            .onTapGesture {
                if allowTapToReveal && (phase == .awaitTap || phase == .progress) {
                    revealClouds(geo: geo)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(phase == .awaitTap ? "點一下繼續" : "載入中")
    }

    // MARK: - Flow Control
    private func startSplashFlow() {
        // Close curtains initially
        topOffset = 0
        bottomOffset = 0
        phase = .covering

        // Start auto progress shortly after appear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            phase = .progress
            runAutoProgress()
        }
    }

    private func runAutoProgress() {
        progress = 0.0
        // Animate to 100% over a fixed duration
        let totalDuration: Double = 2.2
        withAnimation(.easeInOut(duration: totalDuration)) {
            progress = 1.0
        }
        // After it visually completes, allow tap
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 0.1) {
            allowTapToReveal = true
            phase = .awaitTap
        }
    }

    private func revealClouds(geo: GeometryProxy) {
        guard phase == .awaitTap || phase == .progress else { return }
        phase = .revealing
        allowTapToReveal = false

        let travel = geo.size.height * 0.7
        withAnimation(.easeInOut(duration: revealDuration)) {
            topOffset = -travel
            bottomOffset = travel
        }
        // Complete after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + revealDuration) {
            phase = .revealed
        }
    }
}

// MARK: - Fluffy Style (cool white)
private struct FluffyCloudStyle {
    // 蓬鬆程度
    var bubbleCountTop: Int = 14
    var bubbleCountBottom: Int = 10
    var bubbleRadiusRange: ClosedRange<CGFloat> = 0.20...0.50 // 相對於 rect.height
    var horizontalJitter: ClosedRange<CGFloat> = -0.10...0.10
    var verticalJitterTop: ClosedRange<CGFloat> = -0.28...0.04
    var verticalJitterBottom: ClosedRange<CGFloat> = -0.04...0.28
    var baseBodyHeight: CGFloat = 0.40
    var seed: Int = 0

    // 冷白色調
    var coolTint: Color = Color(red: 0.88, green: 0.93, blue: 1.0)
    var coolTint2: Color = Color(red: 0.94, green: 0.97, blue: 1.0)

    // 透明度與陰影
    var opacity: Double = 0.98
    var shadowColor: Color = .black.opacity(0.12)
    var shadowRadius: CGFloat = 22
    var shadowY: CGFloat = 10
}

// MARK: - Cloud Curtains (two big masses)
private struct TopCloudCurtain: View {
    @Environment(\.colorScheme) private var colorScheme

    private var style: FluffyCloudStyle {
        var s = FluffyCloudStyle()
        s.seed = 24680
        if colorScheme == .dark {
            s.opacity = 0.98
            s.shadowColor = .black.opacity(0.28)
            s.shadowRadius = 26
            s.shadowY = 12
        }
        return s
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // 柔和底漸層避免硬邊
            LinearGradient(
                colors: [Color.white.opacity(0.95), Color.white.opacity(0.75)],
                startPoint: .top,
                endPoint: .bottom
            )

            FluffyCloudMass(style: style, alignTop: true)
                .padding(.bottom, 6)
        }
        .background(Color.white.opacity(0.88))
        .clipShape(Rectangle())
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

private struct BottomCloudCurtain: View {
    @Environment(\.colorScheme) private var colorScheme

    private var style: FluffyCloudStyle {
        var s = FluffyCloudStyle()
        s.seed = 13579
        if colorScheme == .dark {
            s.opacity = 0.98
            s.shadowColor = .black.opacity(0.28)
            s.shadowRadius = 26
            s.shadowY = -12
        } else {
            s.shadowY = -10
        }
        return s
    }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [Color.white.opacity(0.95), Color.white.opacity(0.75)],
                startPoint: .bottom,
                endPoint: .top
            )

            FluffyCloudMass(style: style, alignTop: false)
                .padding(.top, 6)
        }
        .background(Color.white.opacity(0.88))
        .clipShape(Rectangle())
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: -6)
    }
}

// MARK: - One Big Cloud Mass
private struct FluffyCloudMass: View {
    let style: FluffyCloudStyle
    let alignTop: Bool

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // 兩層：背景大塊 + 前景大塊，彼此錯落（但仍是一朵）
            ZStack {
                FluffyCloudPiece(style: backgroundStyle, seed: style.seed &+ 11)
                    .fill(cloudGradient(opacity: 0.62))
                    .frame(width: w * 1.1, height: h * 0.82)
                    .offset(x: w * -0.04,
                            y: (alignTop ? -1 : 1) * h * 0.08)
                    .shadow(color: style.shadowColor, radius: style.shadowRadius, x: 0, y: style.shadowY)

                FluffyCloudPiece(style: style, seed: style.seed &+ 29)
                    .fill(cloudGradient(opacity: style.opacity))
                    .frame(width: w * 1.02, height: h * 0.78)
                    .offset(x: w * 0.02,
                            y: (alignTop ? -1 : 1) * h * 0.02)
                    .shadow(color: style.shadowColor.opacity(0.9), radius: style.shadowRadius * 0.8, x: 0, y: style.shadowY * 0.8)
            }
            .frame(width: w, height: h, alignment: alignTop ? .bottom : .top)
        }
    }

    private var backgroundStyle: FluffyCloudStyle {
        var s = style
        s.bubbleCountTop = Int(Double(style.bubbleCountTop) * 0.8)
        s.bubbleCountBottom = Int(Double(style.bubbleCountBottom) * 0.8)
        s.baseBodyHeight = style.baseBodyHeight * 0.95
        return s
    }

    private func cloudGradient(opacity: Double) -> LinearGradient {
        // 冷白：上層更白，下層帶一點點冷藍白，方向依附著雲的開口
        let topColor = Color.white.opacity(opacity)
        let bottomColor = style.coolTint.opacity(opacity)
        return LinearGradient(
            colors: [alignTop ? topColor : bottomColor,
                     alignTop ? bottomColor : topColor],
            startPoint: alignTop ? .top : .bottom,
            endPoint: alignTop ? .bottom : .top
        )
    }
}

// MARK: - Fluffy Cloud Piece (irregular edges)
private struct FluffyCloudPiece: Shape {
    let style: FluffyCloudStyle
    let seed: Int

    func path(in rect: CGRect) -> Path {
        var rng = SeededRandom(seed: seed)

        var p = Path()

        // 主體圓角矩形（厚一點）
        let bodyInsetX = rect.width * 0.06
        let bodyInsetY = rect.height * (1 - style.baseBodyHeight)
        let bodyRect = rect.insetBy(dx: bodyInsetX, dy: bodyInsetY)
        let corner = CGSize(width: bodyRect.height * 0.72, height: bodyRect.height * 0.72)
        p.addRoundedRect(in: bodyRect, cornerSize: corner)

        // 頂部泡泡（不對稱分佈）
        for _ in 0..<style.bubbleCountTop {
            let rx = CGFloat.random(in: 0.08...0.92, rng: &rng)
            let cx = rect.minX + rect.width * rx + rect.width * CGFloat.random(in: style.horizontalJitter, rng: &rng)
            let cy = rect.midY + rect.height * CGFloat.random(in: style.verticalJitterTop, rng: &rng)
            let r = rect.height * CGFloat.random(in: style.bubbleRadiusRange, rng: &rng)
            p.addPath(circle(center: CGPoint(x: cx, y: cy), radius: r))
        }

        // 底部泡泡（讓下緣也蓬鬆）
        for _ in 0..<style.bubbleCountBottom {
            let rx = CGFloat.random(in: 0.08...0.92, rng: &rng)
            let cx = rect.minX + rect.width * rx + rect.width * CGFloat.random(in: style.horizontalJitter, rng: &rng)
            let cy = rect.midY + rect.height * CGFloat.random(in: style.verticalJitterBottom, rng: &rng)
            let r = rect.height * CGFloat.random(in: (style.bubbleRadiusRange.lowerBound*0.85)...(style.bubbleRadiusRange.upperBound*0.9), rng: &rng)
            p.addPath(circle(center: CGPoint(x: cx, y: cy), radius: r))
        }

        // 左右小耳朵（避免輪廓太平）
        let leftEarR = rect.height * CGFloat.random(in: 0.16...0.28, rng: &rng)
        let rightEarR = rect.height * CGFloat.random(in: 0.16...0.28, rng: &rng)
        p.addPath(circle(center: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.midY), radius: leftEarR))
        p.addPath(circle(center: CGPoint(x: rect.maxX - rect.width * 0.06, y: rect.midY), radius: rightEarR))

        return p
    }

    private func circle(center: CGPoint, radius: CGFloat) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: center.x - radius,
                                   y: center.y - radius,
                                   width: radius * 2,
                                   height: radius * 2))
        return path
    }
}

// MARK: - Seeded Random helper
private struct SeededRandom {
    private var state: UInt64
    init(seed: Int) {
        self.state = UInt64(bitPattern: Int64(seed == 0 ? 1 : seed))
    }

    // xorshift*
    mutating func next() -> UInt64 {
        var x = state
        x ^= x >> 12
        x ^= x << 25
        x ^= x >> 27
        state = x
        return x &* 2685821657736338717
    }

    mutating func nextDouble() -> Double {
        let v = next() >> 11 // 53 bits
        return Double(v) / Double(1 << 53)
    }
}

private extension CGFloat {
    static func random(in range: ClosedRange<CGFloat>, rng: inout SeededRandom) -> CGFloat {
        let d = rng.nextDouble()
        return range.lowerBound + (range.upperBound - range.lowerBound) * CGFloat(d)
    }
}

// MARK: - Previews
#Preview {
    HomeView()
        .preferredColorScheme(.light)
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
