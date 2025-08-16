//
//  TodaySummaryView.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//

import SwiftUI

/// # TodaySummary-Metric
/// - TodaySummaryView 공통 Metric
///
enum TodaySummary {
    enum Metric {
        static let contentSpacing = 16.0
        static let contentPadding = 20.0
    }
}

/// # TodaySummaryView 메인(투데이)탭
/// - TodayCardSection (오늘 하루 어떤가요)
/// - ReportCalendarButtonSection(리포트|캘린더)
/// - TodayQuoteSection (오늘의 명언)
/// - RecommendationSection(추천컨텐츠)
/// - RecentRecordSection (최근기록)
///
struct TodaySummaryView: View {
    
    @StateObject var viewModel: TodaySummaryViewModel
    
    init(viewModelFactory: @escaping () -> TodaySummaryViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("How was Today?")
                    .font(.title)
                    .foregroundColor(Color.main)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, TodaySummary.Metric.contentPadding)
                    .padding(.vertical, 8.0)
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
                    // 오늘의 명언
                    RoundedContainer {
                        TodayQuoteSection()
                    }
                    // 추천컨텐츠
                    RoundedContainer {
                        RecommendationSection()
                    }
                    // 최근기록
                    RoundedContainer {
                        RecentRecordSection(viewModel: viewModel)
                    }
                }
                .background(Color.clear)
            }
            .padding(TodaySummary.Metric.contentPadding)
        }
        .background(Color.summaryBackground)
        .onAppear {
            viewModel.loadSupplement()
        }
    }
}

// MARK: - 리포트, 캘린더

/// # ReportCalendarButtonSection
/// - TodaySummaryView 메인(투데이)탭의 리포트 캘린더 섹션
///
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

/// # TodaySummarySectionTitleView
/// - 최근기록, 추천 콘텐츠 섹션 title View
///
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
