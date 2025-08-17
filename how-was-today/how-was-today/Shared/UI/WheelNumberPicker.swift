//
//  WheelNumberPicker.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct WheelNumberPicker: View {
    
    @Binding var selection: Int
    let range: ClosedRange<Int>
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(Array(range), id: \.self) { n in
                Text("\(n)")
                    .tag(n)
                    .font(.title3)
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
        .clipped()
    }
}
