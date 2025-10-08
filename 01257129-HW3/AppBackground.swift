import SwiftUI

struct AppBackground: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        Group {
            if isDarkMode {
                LinearGradient(
                    colors: [Color.black, Color.indigo],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [Color.cyan, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}
