//
//  MoodRecordBottomSheet.swift
//  how-was-today
//
//  Created by stocktong on 8/18/25.
//

import SwiftUI

struct MoodRecordBottomSheet: View {
    private enum Metric {
        static let buttonRadius = 12.0
        static let buttonHeight = 50.0
    }
    
    @EnvironmentObject var router: HowWasTodayRouter
    @StateObject private var viewModel: MoodRecordBottomSheetViewModel
    @State private var selectedMood: Mood?
    
    init(date: Date, viewModelFactory: @escaping (Date) -> MoodRecordBottomSheetViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory(date))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: BottomSheet.Metric.spacing) {
            BottomSheetHeaderView("기분") {
                router.dismissModal()
            }
            FlowLayout(horizontalSpacing: BottomSheet.Metric.spacing, verticalSpacing: BottomSheet.Metric.spacing) {
                ForEach(Mood.allCases, id: \.id) { mood in
                    let isSelected = selectedMood == mood

                    Button {
                        selectedMood = (selectedMood == mood ? nil : mood)
                    } label: {
                        Text(mood.rawValue)
                            .font(.title3)
                            .fontWeight(isSelected ? .semibold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(isSelected ? Color.gray : Color.summaryBackground)
                            .foregroundColor(isSelected ? .white : .black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? .gray : .black.opacity(0.08), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                if viewModel.fetchMood() != nil {
                    RoundedContainer(cornerRadius: Metric.buttonRadius) {
                        Button("지우기") {
                            viewModel.deleteMood()
                            router.dismissModal()
                        }
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(height: Metric.buttonHeight)
                        .frame(maxWidth: .infinity)
                        .background(Color.summaryBackground)
                    }
                }
                RoundedContainer(cornerRadius: Metric.buttonRadius) {
                    Button("저장하기") {
                        if let mood = selectedMood {
                            viewModel.saveMood(mood)
                        }
                        router.dismissModal()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: Metric.buttonHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.main)
                }
            }
        }
        .padding(BottomSheet.Metric.padding)
        .presentationDetents([.medium])
        .onAppear {
            viewModel.refresh()
            self.selectedMood = viewModel.fetchMood()
        }
    }
}
