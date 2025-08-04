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
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("8월 3일(일), 오늘")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)
            // 영양제
            SupplementSection()
            // 건강 및 일상
            HealthSection()
                .padding(.vertical, 8)
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
            
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(hex: "#A3DB91"))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "pill.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("비타민, 오메가3, 루테인")
                        .font(.subheadline)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "checkmark.square")
                        .font(.system(size: 30.0))
                        .foregroundColor(Color(hex: "#dddddd"))
                }
            }
        }
    }
}

// MARK: - 건강 및 일상 섹션

struct HealthSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("건강 및 일상")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.subTitle)
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(hex: "#756355"))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "face.smiling.inverse")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("몸 상태 및 기분")
                        .font(.caption)
                        .foregroundColor(Color.subTitle)
                    Text("소화불량")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            Button(action: {}) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.summaryBackground)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "plus")
                                .foregroundColor(Color.subTitle)
                                .font(.system(size: 16))
                        )
                    
                    Text("기록 추가하기")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .cornerRadius(12)
            }
        }
    }
}
