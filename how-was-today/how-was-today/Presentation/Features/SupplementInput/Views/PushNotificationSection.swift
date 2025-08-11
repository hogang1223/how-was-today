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
    @Binding var time: TimeOfDay?
    @State private var showTimePickerSheet = false
    
    private enum Metric {
        static let toggleTrailingPadding = 4.0
        static let selectButtonSpacing = 8.0
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
                        Text(time?.localizedTimeString() ?? "선택해주세요")
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
