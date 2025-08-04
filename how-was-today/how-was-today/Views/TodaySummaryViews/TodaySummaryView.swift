//
//  TodaySummaryView.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//

import SwiftUI

enum TodaySummary {
    enum Metric {
        static let contentSpacing = 16.0
        static let contentPadding = 20.0
    }
}

struct TodaySummaryView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("How was Today?")
                        .font(.title)
                        .foregroundColor(Color.main)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, TodaySummary.Metric.contentPadding)
                }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: TodaySummary.Metric.contentSpacing) {
                        // 오늘 하루 어떤가요
                        RoundedContainer {
                            TodayCardSection()
                        }
                        // 리포트 캘린더
                        RoundedContainer {
                            ReportCalendarButtonSection()
                        }
                        // 오늘의 농담
                        RoundedContainer {
                            TodayQuoteSection()
                        }
                        // 추천컨텐츠
                        RoundedContainer {
                            RecommendationSection()
                        }
                        // 최근기록
                        RoundedContainer {
                            RecentRecordSection()
                        }
                    }
                    .background(Color.clear)
                }
                .padding(TodaySummary.Metric.contentPadding)
            }
            .navigationBarHidden(true)
            .background(Color.summaryBackground)
        }
    }
}

// MARK: - 리포트, 캘린더

struct ReportCalendarButtonSection: View {
    var body: some View {
        HStack {
            Button("리포트") {}
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity)
            Divider()
            Button("캘린더") {}
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity)
        }
        .padding(10)
        .background(Color.white)
    }
}

// MARK: - SectionTitleView

struct TodaySummarySectionTitleView: View {
    let title: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        HStack(spacing: TodaySummary.Metric.contentSpacing) {
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(buttonTitle, action: buttonAction)
                .foregroundColor(Color.subTitle)
                .font(.subheadline)
        }
    }
}

#Preview {
    TodaySummaryView()
}
