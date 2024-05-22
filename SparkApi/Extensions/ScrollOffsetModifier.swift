//
//  ScrollOffsetModifier.swift
//  NewAPI
//
//  Created by Alex Beattie on 5/8/24.
//

import Foundation
import SwiftUI

struct ScrollViewOffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    let onOffsetChange: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scrollView")).minY)
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onOffsetChange)
    }

    private struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
