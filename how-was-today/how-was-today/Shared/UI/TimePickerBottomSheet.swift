//
//  TimePickerBottomSheet.swift
//  how-was-today
//
//  Created by hogang on 8/7/25.
//

import SwiftUI

/// # 시간 선택 바텀 시트
struct TimePickerBottomSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedTime: TimeOfDay? // 외부에서 받은 선택된 시간
    @State private var tempSelectedTime = Date() // 임시로 선택하는 시간
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20.0) {
                HStack {
                    Text("푸시 알림 시간")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "xmark")
                            .tint(.black)
                            .font(.system(size: 16.0))
                    })
                }
                .background(Color.white)
                
                // Time Picker
                DatePicker("", selection: $tempSelectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    
                // Confirm Button
                Button(action: {
                    selectedTime = TimeOfDay.from(date: tempSelectedTime)
                    isPresented = false
                }, label: {
                    Text("확인")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: SupplementInput.Metric.buttonHeight)
                        .background(Color.main)
                        .cornerRadius(SupplementInput.Metric.buttonCornerRadius)
                })
                    
            }
            .background(Color.white)
            .padding(SupplementInput.Metric.inputViewPadding)
        }
        .onAppear {
            if let existingTime = selectedTime {
                tempSelectedTime = existingTime.date()
            }
        }
        .presentationCornerRadius(32.0)
        .presentationDetents([.height(380)])
    }
}
