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
struct SupplementInputView: View {
    
    @EnvironmentObject var router: HowWasTodayRouter
    @StateObject var viewModel: SupplementInputViewModel
    @State private var pendingFocusIndex: Int?
    
    init(viewModelFactory: @escaping () -> SupplementInputViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
    }
    
    var body: some View {
        ZStack {
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
                        Button("초기화") { viewModel.reset() }
                            .font(.subheadline)
                            .foregroundColor(viewModel.disableReset ? .gray : .black)
                            .disabled(viewModel.disableReset)
                    }
                    Text("영양제 기록")
                        .font(.headline)
                }
                .frame(height: 44.0)
                
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: SupplementInput.Metric.inputViewSpacing) {
                            // 영양제 입력
                            SupplementNameSection(
                                supplements: $viewModel.supplements,
                                pendingFocusIndex: $pendingFocusIndex,
                                onAddSupplement: {
                                    viewModel.addNewSupplements()
                                    pendingFocusIndex = viewModel.supplements.count - 1
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            proxy.scrollTo(SupplementNameSection.identifier, anchor: .bottom)
                                        }
                                    }
                                }
                            )
                            // 알림화면
                            PushNotificationSection(
                                isOn: $viewModel.alarmEnabled,
                                time: $viewModel.alarmTime
                            )
                            Spacer()
                        }
                    }
                    .scrollDismissesKeyboard(.immediately)
                    
                }
            }
            .padding(SupplementInput.Metric.inputViewPadding)
            .onTapGesture {
                endEditing()
            }
            VStack {
                Spacer()
                RoundedContainer(cornerRadius: SupplementInput.Metric.buttonCornerRadius) {
                    Button("저장하기") {
                        viewModel.save()
                        router.pop()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: SupplementInput.Metric.buttonHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.main)
                }
                .padding(.horizontal, SupplementInput.Metric.inputViewPadding)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
