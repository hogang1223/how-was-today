//
//  SupplementNameSection.swift
//  how-was-today
//
//  Created by hogang on 8/7/25.
//

import SwiftUI

/// # 영양제기록 - 영양제 입력 Section
///
struct SupplementNameSection: View {
    
    private enum Metric {
        static let defaultSupplementsCount = 3
        
        static let addButtonCorenerRadius = 8.0
        static let addButtonVerticalPadding = 10.0
        static let addButtonHorizontalPadding = 16.0
    }

    @State private var supplements: [String] = Array(repeating: "", count: Metric.defaultSupplementsCount)
    @FocusState private var focusedIndex: Int?  // 👈 포커스 상태
    
    var body: some View {
        VStack(alignment: .leading, spacing: SupplementInput.Metric.sectionSpacing) {
            Text("어떤 영양제를 먹나요?")
                .font(.headline)
                .foregroundColor(.black)
            
            // TextField
            VStack(spacing: SupplementInput.Metric.sectionCardSpacing) {
                ForEach(0..<supplements.count, id: \.self) { index in
                    var text = supplements[index]
                    RoundedTextField(text: Binding(
                        get: { text },
                        set: { text = $0 }
                    ), placeholder: "영양제 이름")
                    .focused($focusedIndex, equals: index)
                    .padding(.horizontal, 1.0)
                }
            }
            RoundedContainer(cornerRadius: Metric.addButtonCorenerRadius) {
                Button("추가하기") {
                    supplements.append("")
                    focusedIndex = supplements.count - 1
                }
                .foregroundColor(.black)
                .padding(.vertical, Metric.addButtonVerticalPadding)
                .padding(.horizontal, Metric.addButtonHorizontalPadding)
                .background(Color.summaryBackground)
            }
        }
    }
}
