//
//  FetchSupplementUseCase.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import Foundation

/// 특정 날짜의 영양제 정보(플랜 + 당일 복용 여부)를 조회하는 유즈케이스
protocol FetchSupplementUseCase {
    func execute(date: Date) -> Supplement
}

struct FetchSupplementUseCaseImpl: FetchSupplementUseCase {
    
    private let planRepo: SupplementPlanRepository
    private let logRepo: DailySupplementLogRepository
    
    init(planRepo: SupplementPlanRepository, logRepo: DailySupplementLogRepository) {
        self.planRepo = planRepo
        self.logRepo = logRepo
    }
    
    func execute(date: Date) -> Supplement {
        var supplement = planRepo.fetchPlan(date: date)
        let log = logRepo.fetchIsTaken(on: date)
        supplement.isTaken = log
        return supplement
    }
}
