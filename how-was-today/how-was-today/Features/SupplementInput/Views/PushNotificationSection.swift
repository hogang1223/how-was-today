//
//  PushNotificationSection.swift
//  how-was-today
//
//  Created by hogang on 8/7/25.
//

import SwiftUI

/// # 영양제 알림 설정 Section
/// 
struct PushNotificationSection: View {
    
    @State private var shouldAddToToday = false
    @State private var showTimePickerSheet = false
    @State private var selectedTime: Date?
    
    private enum Metric {
        static let toggleTrailingPadding = 4.0
        static let selectButtonSpacing = 8.0
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        // 현재 locale이 24시간제인지 확인
        let locale = Locale.autoupdatingCurrent
        let template = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)
        
        if template?.contains("a") == true {
            // 12시간제 (오전/오후 표시)
            formatter.dateFormat = "a h:mm"
        } else {
            // 24시간제
            formatter.dateFormat = "HH:mm"
        }
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: SupplementInput.Metric.sectionSpacing) {
            Text("매일 푸시로 알려드릴까요?")
                .font(.headline)
                .foregroundColor(.black)
            // 알림
            HStack {
                Text("알림")
                Spacer()
                Toggle("", isOn: $shouldAddToToday)
                    .toggleStyle(SwitchToggleStyle(tint: .main))
                    .onChange(of: shouldAddToToday) { newValue in
                        if newValue {
                            showTimePickerSheet = true
                        } else {
                            selectedTime = nil
                        }
                    }
                    .padding(.trailing, Metric.toggleTrailingPadding)
            }
            // 시간
            HStack {
                Text("시간")
                Spacer()
                Button(action: {
                    shouldAddToToday = true
                    showTimePickerSheet = true
                }, label: {
                    HStack(spacing: Metric.selectButtonSpacing) {
                        Text(selectedTime == nil ? "선택해주세요" : timeFormatter.string(from: selectedTime!))
                            .foregroundColor(.main)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.placeholder)
                            .font(.caption2)
                    }
                })
            }
        }
        .sheet(isPresented: $showTimePickerSheet) {
            TimePickerBottomSheet(isPresented: $showTimePickerSheet, selectedTime: $selectedTime)
        }
    }
}
