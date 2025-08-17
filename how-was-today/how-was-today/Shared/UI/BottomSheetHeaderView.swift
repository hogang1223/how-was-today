//
//  BottomSheetHeaderView.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

enum BottomSheet {
    enum Metric {
        static let padding = 20.0
        static let spacing = 20.0
        static let cornerRadius = 32.0
    }
}

struct BottomSheetHeaderView: View {
    let title: String
    let action: (() -> Void)?
    
    init(_ title: String, action: (() -> Void)?) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            Spacer()
            Button {
                if let dismiss = action {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16))
                    .foregroundStyle(.black)
            }
        }
    }
}
