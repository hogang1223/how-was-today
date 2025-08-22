//
//  View+Keyboard.swift
//  how-was-today
//
//  Created by stocktong on 8/20/25.
//

import SwiftUI
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
