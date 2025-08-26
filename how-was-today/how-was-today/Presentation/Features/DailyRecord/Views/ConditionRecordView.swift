//
//  ConditionRecordView.swift
//  how-was-today
//
//  Created by hogang on 8/19/25.
//

import SwiftUI

struct ConditionRecordView: View {
    @EnvironmentObject var router: HowWasTodayRouter
    @StateObject var viewModel: ConditionRecordViewModel<ConditionStore>
    
    init(date: Date, viewModelFactory: @escaping (Date) -> ConditionRecordViewModel<ConditionStore>) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory(date))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 36) {
                    ForEach(ConditionType.allCases) { type in
                        VStack(alignment: .leading, spacing: 20.0) {
                            Text(type.title)
                                .font(.subheadline)
                                .foregroundColor(.subTitle)
                            let options = ConditionCatalog.options(for: type)
                            FlowLayout(horizontalSpacing: 16.0, verticalSpacing: 8.0) {
                                ForEach(options) { option in
                                    TagRow(
                                        option: option,
                                        isSelected: viewModel.options.contains(option)) {
                                            viewModel.toggle(option)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
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
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.refresh()
        }
        .appNavigationBar(title: "몸 상태") {
            Button("초기화") { viewModel.reset() }
                .font(.subheadline)
                .foregroundColor(viewModel.disableReset ? .gray : .black)
                .disabled(viewModel.disableReset)
        }
    }
}

struct TagRow: View {
    let option: ConditionOption
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        RoundedContainer(cornerRadius: 8.0) {
            Button(action: onTap) {
                HStack(spacing: 8) {
                    if let icon = option.icon {
                        Image(systemName: icon)
                    }
                    Text(option.titleKey) // 로컬라이징 키를 바로 타이틀로 사용 중
                        .font(.subheadline)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.main : Color.summaryBackground)
                .foregroundStyle(isSelected ? .white : .black)
            }
        }
    }
}
