//
//  RecomendationSection.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//

import SwiftUI

private enum Metric {
    static let cardViewRadius = 8.0
    static let spacing = 8.0
    static let imageSize = 20.0
    static let fontSize = 16.0
}

/// # TodaySummaryView 추천콘텐츠 Section
/// - 추천콘텐츠, 검색하기 타이틀
/// - 추천 콘텐츠 카드 뷰
///
struct RecommendationSection: View {
    // FIXME: ViewModel에서 데이터 가져오기
    let recommendations: [RecommendationContent] = [
        RecommendationContent(imageName: "fireworks", title: "오늘의 운세"),
        RecommendationContent(imageName: "chart.xyaxis.line", title: "바이오리듬"),
        RecommendationContent(imageName: "sun.max", title: "오늘의 날씨"),
        RecommendationContent(imageName: "moon.stars.fill", title: "오늘의 타로"),
        RecommendationContent(imageName: "cellularbars", title: "감정그래프")
    ]
    var body: some View {
        VStack(spacing: TodaySummary.Metric.contentSpacing) {
            TodaySummarySectionTitleView(
                title: "추천 콘텐츠",
                buttonTitle: "검색하기"
            ) {
                // action
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: TodaySummary.Metric.contentSpacing) {
                    ForEach(recommendations, id: \.self) { content in
                        RecommendationCardView(
                            systemImageName: content.imageName,
                            title: content.title
                        )
                    }
                }
            }
        }
        .padding(TodaySummary.Metric.contentPadding)
        .background(Color.white)
    }
}

struct RecommendationCardView: View {
    let systemImageName: String
    let title: String
    
    var body: some View {
        RoundedContainer(cornerRadius: Metric.cardViewRadius) {
            HStack(spacing: Metric.spacing) {
                Image(systemName: systemImageName)
                    .font(.system(size: Metric.imageSize))
                Text(title)
                    .font(.system(size: Metric.fontSize))
            }
            .padding(TodaySummary.Metric.contentPadding)
            .background(Color.summaryBackground)
        }
    }
}
