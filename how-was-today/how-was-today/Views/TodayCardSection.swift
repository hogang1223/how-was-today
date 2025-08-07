//
//  TodayCardSection.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//

import SwiftUI

/// # TodaySummaryView 오늘 하루 카드 Section
/// - 오늘 하루 어땠나요
///
struct TodayCardSection: View {
    var body: some View {
        HStack(spacing: TodaySummary.Metric.contentSpacing) {
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 32.0))
                .foregroundColor(Color.yellow)
            VStack(spacing: 4.0) {
                Text("오늘 하루는 어떤가요?")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("오늘기록하기") {}
                    .foregroundColor(Color.main)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack {
                Button(action: {}, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                })
                .padding(.top, 8)
                Spacer()
            }
        }
        .padding(TodaySummary.Metric.contentPadding)
        .background(Color.white)
    }
}
