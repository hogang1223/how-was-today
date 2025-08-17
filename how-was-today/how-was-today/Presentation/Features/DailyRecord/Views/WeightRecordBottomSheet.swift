//
//  WeightRecordBottomSheet.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct WeightRecordBottomSheet: View {
    private enum Metric {
        static let sheetHeight = 360.0
        static let buttonRadius = 12.0
        static let buttonHeight = 50.0
        
        static let intPartPickerWidth = 120.0
        static let fracPartPickerWidth = 80.0
    }
    
    private let min: Int = 1
    private let max: Int = 300

    @State private var intPart: Int = 50
    @State private var fracPart: Int = 0

    private var currentValue: Double {
        Double(intPart) + Double(fracPart) / 10.0
    }
    
    @EnvironmentObject var router: HowWasTodayRouter
    
    var body: some View {
        VStack(spacing: BottomSheet.Metric.spacing) {
            BottomSheetHeaderView("체중") {
                router.dismissModal()
            }

            // 피커
            HStack(alignment: .center) {
                WheelNumberPicker(selection: $intPart, range: min...max)
                    .frame(width: Metric.intPartPickerWidth)

                Text(".")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                WheelNumberPicker(selection: $fracPart, range: 0...9)
                    .frame(width: Metric.fracPartPickerWidth)

                Text("kg")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            RoundedContainer(cornerRadius: Metric.buttonRadius) {
                Button("저장하기") {
                    // TODO: 데이터 저장
                    router.dismissModal()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(height: Metric.buttonHeight)
                .frame(maxWidth: .infinity)
                .background(Color.main)
            }
        }
        .padding(BottomSheet.Metric.padding)
        .presentationDetents([.height(Metric.sheetHeight)])
    }
}
