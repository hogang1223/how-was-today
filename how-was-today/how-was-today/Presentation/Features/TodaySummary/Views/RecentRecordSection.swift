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
    
    @EnvironmentObject var router: HowWasTodayRouter
    @ObservedObject var viewModel: TodaySummaryViewModel
    
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
            Button(action: {
                router.push(.inputSupplement)
            }, label: {
                SupplementSection(
                    supplements: Binding(
                        get: { viewModel.supplement.names },
                        set: { viewModel.supplement.names = $0 }
                    ),
                    isSelected: Binding(
                        get: { viewModel.supplement.isTaken },
                        set: { viewModel.toggleSupplementIsTaken($0) }
                    )
                )
            })
            // 건강 및 일상
            HealthSection(viewModel: viewModel)
                .padding(.vertical, Metric.padding)
        }
        .padding(TodaySummary.Metric.contentPadding)
        .background(Color.white)
    }
}

// MARK: - 영양제 섹션

struct SupplementSection: View {
    @Binding var supplements: [String]
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: TodaySummary.Metric.contentSpacing) {
            Text("영양제")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.subTitle)
            
            HStack {
                RecentRecordCardView(
                    systemImageName: "pill.fill",
                    imageBackgroundColor: Color.supplement,
                    details: supplements.isEmpty ? "영양제먹기" : supplements.joined(separator: ", ")
                )
                Button(action: {
                    isSelected.toggle()
                }, label: {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "checkmark.square")
                        .font(.system(size: Metric.checkBoxImageSize))
                        .foregroundColor(isSelected ? .green : .placeholder)
                })
            }
        }
    }
}

// MARK: - 건강 및 일상 섹션

struct HealthSection: View {
    
    @EnvironmentObject var router: HowWasTodayRouter
    @ObservedObject var viewModel: TodaySummaryViewModel

    private let features = DailyRecord.all

    var body: some View {
        VStack(alignment: .leading, spacing: Metric.healthSectionSpacing) {
            Text("건강 및 일상")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.subTitle)

            ForEach(features, id: \.id) { f in
                if let details = getDetails(feature: f) {
                    Button(action: {
                        if let route = f.getRoute(date: viewModel.date) {
                            router.push(route)
                        } else if let modal = f.getModal(date: viewModel.date) {
                            router.present(modal)
                        }
                    }, label: {
                        RecentRecordCardView(
                            systemImageName: f.systemImageName,
                            imageBackgroundColor: f.imageColor,
                            categoryTitle: f.title,
                            details: details
                        )
                    })
                }
            }

            // 기록하기 버튼
            Button(action: {
                router.present(.dailyRecord(date: viewModel.date))
            }, label: {
                RecentRecordCardView(
                    systemImageName: "plus",
                    imageBackgroundColor: Color.summaryBackground,
                    imageColor: Color.subTitle,
                    details: "기록 추가하기"
                )
            })
        }
    }
    
    private func getDetails(feature: any DailyRecordFeature) -> String? {
        switch feature.id {
        case .weight:
            return viewModel.dailyRecord.weight
        case .mood:
            return viewModel.dailyRecord.mood
        case .condition:
            return viewModel.dailyRecord.condition
        case .memo:
            return viewModel.dailyRecord.memo
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
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            Spacer()
        }
    }
}
