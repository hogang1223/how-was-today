//
//  RoundedTextField.swift
//  how-was-today
//
//  Created by hogang on 8/7/25.
//

import SwiftUI

struct RoundedTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var placeholder: String = ""
    
    var body: some View {
        TextField(placeholder, text: $text)
            .focused($isFocused)
            .padding(16)
            .tint(.main)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.main : Color(.systemGray4), lineWidth: 1)
                    .background(Color.white)
            )
    }
}
