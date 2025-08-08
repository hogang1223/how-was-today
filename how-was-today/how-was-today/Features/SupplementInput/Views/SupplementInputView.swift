//
//  SupplementInputView.swift
//  how-was-today
//
//  Created by stocktong on 8/7/25.
//

import SwiftUI

/// # SupplementInput-Metric
/// - 영양제 기록 관련 화면 공통 제약사항

enum SupplementInput {
    enum Metric {
        static let inputViewSpacing = 40.0
        static let inputViewPadding = 20.0
        
        static let buttonHeight = 50.0
        static let buttonCornerRadius = 12.0
        
        static let sectionSpacing = 20.0
        static let sectionCardSpacing = 12.0
    }
}

/// # SupplementInputView 영양제 기록
/// - SupplementNameSection (영양제 입력)
/// - PushNotificationSection (푸시 알림 설정)
///
struct SupplementInputView: View {
    
    @EnvironmentObject var router: HowWasTodayRouter
    
    var body: some View {
        VStack {
        // TODO: NavigationView 따로 분리하기
            ZStack {
                HStack {
                    Button(action: {
                        router.pop()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                    })
                    Spacer()
                    Button(action: {
                    }, label: {
                        Text("초기화")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    })
                }
                Text("영양제 기록")
                    .font(.headline)
            }
            .frame(height: 44.0)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SupplementInput.Metric.inputViewSpacing) {
                    // 영양제 입력
                    SupplementNameSection()
                    
                    PushNotificationSection()
                    Spacer()
                }
            }
            .scrollDismissesKeyboard(.immediately)
            Spacer() // 하단 버튼 공간 확보
            // 저장하기
            RoundedContainer(cornerRadius: SupplementInput.Metric.buttonCornerRadius) {
                Button(action: {
                    
                }, label: {
                    Text("저장하기")
                        .font(.headline)
                        .foregroundStyle(.white)
                })
                .frame(height: SupplementInput.Metric.buttonHeight)
                .frame(maxWidth: .infinity)
                .background(Color.main)
            }
        }
        .padding(SupplementInput.Metric.inputViewPadding)
        .onTapGesture {
            endEditing()
        }
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
