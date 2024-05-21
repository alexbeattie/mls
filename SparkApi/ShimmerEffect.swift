//
//  ShimmerEffect.swift
//  NewAPI
//
//  Created by Alex Beattie on 5/8/24.
//

import Foundation
import SwiftUI

struct ShimmerEffect: View {
    @State private var isLoading = false
    var width: CGFloat = 200
    var height: CGFloat = 200
    var cornerRadius: CGFloat = 10

    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .mask(RoundedRectangle(cornerRadius: 10))

            Color.white
                .mask(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .white.opacity(0.5), .clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.init(degrees: 70))
                        .offset(x: isLoading ? width : -width)
                    )
                }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isLoading = true
            }
        }
    }
}
