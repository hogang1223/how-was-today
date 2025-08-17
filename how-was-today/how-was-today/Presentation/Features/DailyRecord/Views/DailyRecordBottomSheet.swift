//
//  DailyRecordBottomSheet.swift
//  how-was-today
//
//  Created by hogang on 8/16/25.
//

import SwiftUI

private enum Metric {
    static let iconImageFrameSize = 54.0
    static let iconImageSize = 24.0
    static let sheetHeight = 300.0
}

struct DailyRecordBottomSheet: View {
    @EnvironmentObject var router: HowWasTodayRouter
    
    private let features = DailyRecordRegistry.all
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: BottomSheet.Metric.spacing) {
            BottomSheetHeaderView("기록 추가") {
                router.dismissModal()
            }
            LazyVGrid(columns: columns, spacing: BottomSheet.Metric.spacing) {
                ForEach(features, id: \.id) { f in
                    Button(action: {
                        if let route = f.route {
                            router.push(route)
                        } else if let modal = f.modal {
                            router.present(modal)
                        }
                    }, label: {
                        VStack {
                            Circle()
                                .fill(f.imageColor)
                                .frame(width: Metric.iconImageFrameSize, height: Metric.iconImageFrameSize)
                                .overlay(
                                    Image(systemName: f.systemImageName)
                                        .foregroundColor(.white)
                                        .font(.system(size: Metric.iconImageSize))
                                )
                            Text(f.title)
                                .font(.headline)
                                .foregroundStyle(Color.subTitle)
                        }
                    })
                    .frame(maxWidth: .infinity)
                }
            }
            Spacer()
        }
        .padding(BottomSheet.Metric.padding)
        .presentationDetents([.height(Metric.sheetHeight)])
    }
}
