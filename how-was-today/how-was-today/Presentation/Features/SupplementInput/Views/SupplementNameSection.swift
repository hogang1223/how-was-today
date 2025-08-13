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
    
    private let maxSupplementsCount = 20
    static let identifier: String = "supplement-name-section"
    
    private enum Metric {
        static let addButtonCornerRadius = 8.0
        static let addButtonVerticalPadding = 10.0
        static let addButtonHorizontalPadding = 16.0
    }
    
    @Binding var supplements: [String]
    @Binding var pendingFocusIndex: Int?
    var onAddSupplement: () -> Void
    @FocusState private var focusedIndex: Int?  // 포커스 상태
    
    var body: some View {
        VStack(alignment: .leading, spacing: SupplementInput.Metric.sectionSpacing) {
            Text("어떤 영양제를 먹나요?")
                .font(.headline)
                .foregroundColor(.black)
            
            // TextField
            VStack(spacing: SupplementInput.Metric.sectionCardSpacing) {
                ForEach(0..<supplements.count, id: \.self) { index in
                    RoundedTextField(
                        text: $supplements[index],
                        placeholder: "영양제 이름"
                    )
                        .focused($focusedIndex, equals: index)
                        .padding(.horizontal, 1.0)
                        .onAppear {
                            if pendingFocusIndex == index {
                                DispatchQueue.main.async {
                                    focusedIndex = index
                                    pendingFocusIndex = nil
                                }
                            }
                        }
                        .onChange(of: pendingFocusIndex) { req in
                            if req == index {
                                DispatchQueue.main.async {
                                    focusedIndex = index
                                    pendingFocusIndex = nil
                                }
                            }
                        }
                }
            }
            if supplements.count < maxSupplementsCount {
                RoundedContainer(cornerRadius: Metric.addButtonCornerRadius) {
                    Button("추가하기") {
                        onAddSupplement()
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, Metric.addButtonVerticalPadding)
                    .padding(.horizontal, Metric.addButtonHorizontalPadding)
                    .background(Color.summaryBackground)
                }
            }
        }
        .id(Self.identifier)
    }
}
