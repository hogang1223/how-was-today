//
//  TodayQuoteSection.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//

import SwiftUI

/// # TodaySummaryView 명언 Section
/// - 오늘의 명언
///
struct TodayQuoteSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing:TodaySummary.Metric.contentSpacing) {
                Text("8월 3일(일)")
                    .font(.subheadline)
                    .foregroundColor(Color.subTitle)
            HStack {
                Text("오늘의 명언")
                    .font(.headline)
                    .foregroundColor(Color.black)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(Color.subTitle)
                }
            }
            Text("반드시 이겨야 하는 건 아니지만 진실할 필요는 있다. 반드시 성공해야 하는 건 아니지만, 소신을 가지고 살아야 할 필요는 있다.")
                .foregroundColor(Color.black)
            Text("에이브러햄 링컨 (미국 16대 대통령)")
                .font(.caption)
                .foregroundColor(Color.subTitle)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(TodaySummary.Metric.contentPadding)
        .background(Color.white)
    }
}
