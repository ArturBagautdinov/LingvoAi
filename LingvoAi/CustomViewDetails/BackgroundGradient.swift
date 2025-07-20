import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(colors: [.black, .black, .bluePurple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundGradient()
}
