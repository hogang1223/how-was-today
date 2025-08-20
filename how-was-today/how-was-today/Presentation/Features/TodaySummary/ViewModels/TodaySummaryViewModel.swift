//
//  TodaySummaryViewModel.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import Foundation

struct SupplementUseCaseFactory {
    let makeFetch: () -> FetchSupplementUseCase
    let makeToggle: () -> ToggleSupplementTakenUseCase
}

final class TodaySummaryViewModel: ObservableObject {
    
    @Published var date: Date
    @Published var supplement: Supplement
    @Published var dailyRecord: DailyRecord

    private let factory: SupplementUseCaseFactory
    private let fetchDailyRecordUC: FetchDailyRecordUseCase
    
    init(
        factory: SupplementUseCaseFactory,
        fetchDailyRecordUC: FetchDailyRecordUseCase
    ) {
        self.factory = factory
        self.fetchDailyRecordUC = fetchDailyRecordUC
        
        let now = Date()
        self.date = now
        self.supplement = Supplement(date: now, names: [])
        self.dailyRecord = DailyRecord(date: now)
        
        loadSupplement()
    }
}

// MARK: - Supplement

extension TodaySummaryViewModel {
    func loadSupplement() {
        let uc = factory.makeFetch()
        supplement = uc.execute(date: date)
    }
    
    func toggleSupplementIsTaken(_ isTaken: Bool) {
        let uc = factory.makeToggle()
        do {
            try uc.execute(date: date, isTaken: isTaken)
            supplement.isTaken = isTaken
        } catch {
            print("toggle Supplement is taken error \(error.localizedDescription)")
        }
    }
}

// MARK: - DailyRecord

extension TodaySummaryViewModel {
    
    func refreshDailyRecord() {
        fetchDailyRecordUC.refresh(date: date)
    }
    
    func fetchDailyRecord() {
        dailyRecord = fetchDailyRecordUC.fetch(date: date)
    }
}
