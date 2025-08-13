//
//  RoundedContainer.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//

import SwiftUI

struct RoundedContainer<Content: View>: View {
    let cornerRadius: CGFloat
    let content: () -> Content

    init(cornerRadius: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content
    }

    var body: some View {
        content()
            .cornerRadius(cornerRadius)
    }
}
