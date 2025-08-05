//
//  RecentRecordSection.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//
import SwiftUI

/// # TodaySummaryView 최근 기록 Section
/// - 날짜 변경
/// - 영양제
/// - 건강 및 일상
///
private enum Metric {
    static let iconImageFrameSize = 36.0
    static let iconImageSize = 16.0
    static let checkBoxImageSize = 30.0
    static let padding = 8.0
    static let healthSectionSpacing = 20.0
    static let cardViewSpacing = 12.0
}

struct RecentRecordSection: View {
    var body: some View {
        VStack(spacing: TodaySummary.Metric.contentPadding) {
            // 타이틀
            TodaySummarySectionTitleView(
                title: "최근 기록",
                buttonTitle: "캘린더로 보기"
            ) {
                // action
            }
            // 날짜 네비게이션
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                })
                
                Spacer()
                
                Text("8월 3일(일), 오늘")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: {}, label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                })
            }
            .padding(.horizontal, Metric.padding)
            // 영양제
            SupplementSection()
            // 건강 및 일상
            HealthSection()
                .padding(.vertical, Metric.padding)
        }
        .padding(TodaySummary.Metric.contentPadding)
        .background(Color.white)
    }
}

// MARK: - 영양제 섹션

struct SupplementSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TodaySummary.Metric.contentSpacing) {
            Text("영양제")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.subTitle)
            
            // FIXME: details 데이터 사용자 입력값으로 변경 필요
            HStack {
                RecentRecordCardView(
                    systemImageName: "pill.fill",
                    imageBackgroundColor: Color.supplement,
                    details: "영양제먹기"
                )
                Button(action: {}, label: {
                    Image(systemName: "checkmark.square")
                        .font(.system(size: Metric.checkBoxImageSize))
                        .foregroundColor(.placeholder)
                })
            }
        }
    }
}

// MARK: - 건강 및 일상 섹션

struct HealthSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Metric.healthSectionSpacing) {
            Text("건강 및 일상")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.subTitle)
            
            // FIXME: 사용자가 입력한 데이터 보여줄 수 있도록 변경 필요
            RecentRecordCardView(
                systemImageName: "face.smiling.inverse",
                imageBackgroundColor: Color.health,
                categoryTitle: "몸 상태 및 기분",
                details: "소화불량"
            )
            // 기록하기 버튼
            Button(action: {}, label: {
                RecentRecordCardView(
                    systemImageName: "plus",
                    imageBackgroundColor: Color.summaryBackground,
                    imageColor: Color.subTitle,
                    details: "기록 추가하기"
                )
            })
        }
    }
}

struct RecentRecordCardView: View {
    let systemImageName: String
    let imageBackgroundColor: Color
    let imageColor: Color?
    let categoryTitle: String?
    let details: String
    
    init(systemImageName: String, imageBackgroundColor: Color, imageColor: Color? = nil,
         categoryTitle: String? = nil, details: String
    ) {
        self.systemImageName = systemImageName
        self.imageBackgroundColor = imageBackgroundColor
        self.imageColor = imageColor
        self.categoryTitle = categoryTitle
        self.details = details
    }
    
    var body: some View {
        HStack(spacing: Metric.cardViewSpacing) {
            Circle()
                .fill(imageBackgroundColor)
                .frame(width: Metric.iconImageFrameSize, height: Metric.iconImageFrameSize)
                .overlay(
                    Image(systemName: systemImageName)
                        .foregroundColor(imageColor ?? .white)
                        .font(.system(size: Metric.iconImageSize))
                )
            VStack(alignment: .leading, spacing: 4) {
                if let title = categoryTitle {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(Color.subTitle)
                }
                Text(details)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            Spacer()
        }
    }
}
