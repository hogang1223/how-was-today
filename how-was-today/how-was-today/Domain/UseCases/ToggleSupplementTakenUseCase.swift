//
//  ToggleSupplementTakenUseCase.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import Foundation

/// 하루 복용 여부를 설정하는 유즈케이스
protocol ToggleSupplementTakenUseCase {
    func execute(date: Date, isTaken: Bool) throws
}

struct ToggleSupplementTakenUseCaseImpl: ToggleSupplementTakenUseCase {
    private let logRepo: DailySupplementLogRepository
    
    init(logRepo: DailySupplementLogRepository) {
        self.logRepo = logRepo
    }
    
    func execute(date: Date, isTaken: Bool) throws {
        try logRepo.saveIsTaken(on: date, isTaken)
    }
}
