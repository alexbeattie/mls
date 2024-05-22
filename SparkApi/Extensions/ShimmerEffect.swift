import SwiftUI

struct ShimmerEffect: View {
    var cornerRadius: CGFloat = 0
    var height: CGFloat? = nil
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.3))
            .shimmering()
            .frame(height: height)
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerEffectModifier())
    }
}

struct ShimmerEffectModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                     Color.gray.opacity(0.3)
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .white.opacity(0.5), .clear]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .rotationEffect(.degrees(30))
                                .offset(x: phase * geometry.size.width, y: 0)
                        )
                }

            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}
