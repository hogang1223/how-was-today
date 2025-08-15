//
//  TodaySummaryViewModel.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import Foundation

final class TotalSummaryViewModel: ObservableObject {
    
    @Published var supplement: Supplement
    
    private let supplementRepo: SupplementPlanRepository
    
    init(supplementRepo: SupplementPlanRepository) {
        self.supplementRepo = supplementRepo
        
        self.supplement = Supplement(date: Date(), names: [])
        
        loadSupplement()
    }
    
    
    private func loadSupplement() {
        
    }
}
