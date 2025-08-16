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
    
    @Published var supplement: Supplement
    @Published var date: Date

    private let factory: SupplementUseCaseFactory
    
    init(factory: SupplementUseCaseFactory) {
        self.factory = factory
        
        let now = Date()
        self.date = now
        self.supplement = Supplement(date: now, names: [])
        
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
