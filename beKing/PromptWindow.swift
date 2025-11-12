import SwiftUI

struct PromptWindow: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("beKing")
                .font(.headline)
            Text("This is your prompt placeholder.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .frame(minWidth: 360, minHeight: 220)
        .padding(20)
    }
}
