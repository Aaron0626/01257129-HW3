import SwiftUI

public struct FlipCard<Front: View, Back: View>: View {
    @Binding private var isFlipped: Bool
    private let duration: Double
    private let axis: (x: CGFloat, y: CGFloat)
    private let perspective: CGFloat
    @ViewBuilder private let front: () -> Front
    @ViewBuilder private let back: () -> Back

    public init(
        isFlipped: Binding<Bool>,
        duration: Double = 0.45,
        axis: (x: CGFloat, y: CGFloat) = (0, 1),
        perspective: CGFloat = 0.6,
        @ViewBuilder front: @escaping () -> Front,
        @ViewBuilder back: @escaping () -> Back
    ) {
        self._isFlipped = isFlipped
        self.duration = duration
        self.axis = axis
        self.perspective = perspective
        self.front = front
        self.back = back
    }

    public var body: some View {
        ZStack {
            front()
                .opacity(isFlipped ? 0.0 : 1.0)
                .rotation3DEffect(.degrees(isFlipped ? 90 : 0), axis: (1,1,1), perspective: 0.7)

            back()
                .opacity(isFlipped ? 1.0 : 0.0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -90), axis: (1,1,1), perspective: 0.7)
        }
        .animation(.easeInOut(duration: duration), value: isFlipped)
    }
}
