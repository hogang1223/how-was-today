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
    
    @EnvironmentObject var router: HowWasTodayRouter
    @StateObject private var viewModel: WeightRecordBottomSheetViewModel

    @State private var intPart: Int = 0
    @State private var fracPart: Int = 0
    
    init(date: Date, vmFactory: @escaping (Date) -> WeightRecordBottomSheetViewModel) {
        self._viewModel = StateObject(wrappedValue: vmFactory(date))
    }
    
    var body: some View {
        VStack(spacing: BottomSheet.Metric.spacing) {
            BottomSheetHeaderView("체중") {
                router.dismissModal()
            }

            // 피커
            HStack(alignment: .center) {
                WheelNumberPicker(selection: $intPart, range: 1...300)
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
            HStack(spacing: BottomSheet.Metric.spacing) {
                if viewModel.hasWeightRecord() {
                    RoundedContainer(cornerRadius: Metric.buttonRadius) {
                        Button("지우기") {
                            viewModel.deleteWeight()
                            router.dismissModal()
                        }
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(height: Metric.buttonHeight)
                        .frame(maxWidth: .infinity)
                        .background(Color.summaryBackground)
                    }
                }
                RoundedContainer(cornerRadius: Metric.buttonRadius) {
                    Button("저장하기") {
                        let weight = Double(intPart) + (Double(fracPart) / 10.0)
                        viewModel.saveWeight(weight)
                        router.dismissModal()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: Metric.buttonHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.main)
                }
            }
        }
        .padding(BottomSheet.Metric.padding)
        .presentationDetents([.height(Metric.sheetHeight)])
        .onAppear {
            let w10 = Int((viewModel.fetchWeight() * 10).rounded())
            intPart = w10 / 10
            fracPart = w10 % 10
        }
    }
}
