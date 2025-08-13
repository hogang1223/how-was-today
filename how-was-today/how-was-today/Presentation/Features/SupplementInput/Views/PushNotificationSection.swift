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
    
    @Binding var isOn: Bool
    @Binding var time: Date?
    @State private var showTimePickerSheet = false
    
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
                Toggle("", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: .main))
                    .onChange(of: isOn) { newValue in
                        if newValue {
                            showTimePickerSheet = true
                        } else {
                            time = nil
                        }
                    }
                    .padding(.trailing, Metric.toggleTrailingPadding)
            }
            // 시간
            HStack {
                Text("시간")
                Spacer()
                Button(action: {
                    isOn = true
                    showTimePickerSheet = true
                }, label: {
                    HStack(spacing: Metric.selectButtonSpacing) {
                        Text(time == nil ? "선택해주세요" : timeFormatter.string(from: time!))
                            .foregroundColor(.main)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.placeholder)
                            .font(.caption2)
                    }
                })
            }
        }
        .sheet(isPresented: $showTimePickerSheet) {
            TimePickerBottomSheet(
                isPresented: $showTimePickerSheet,
                selectedTime: $time
            )
        }
    }
}
