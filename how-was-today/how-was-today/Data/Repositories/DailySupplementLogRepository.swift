//
//  DailySupplementLogRepository.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import Foundation

/// # DailySupplementLogRepository
/// - 하루 복용 여부(`isTaken`)를 단일 비트로 저장/조회하는 저장소
protocol DailySupplementLogRepository {
    /// 특정 날짜의 복용 여부 조회
    /// - Parameter date: 조회할 날짜
    /// - Returns: 해당 날짜의 로그가 있고 `isTaken`이 true면 true, 아니면 false
    func fetchIsTaken(on date: Date) -> Bool
    
    /// 특정 날짜의 복용 여부 설정
    /// - Parameter date: 설정할 날짜
    /// - Parameter value: 복용 여부(true/false)
    func setIsTaken(on date: Date, _ value: Bool) throws
}

final class DailySupplementLogRepositoryImpl<Storage: DataStorage>: DailySupplementLogRepository
where Storage.ObjectType == DailySupplementLog {

    private let storage: Storage
    init(storage: Storage) { self.storage = storage }

    func fetchIsTaken(on date: Date) -> Bool {
        let key = date.toString(format: Supplement.dateFormat)
        let p = NSPredicate(format: "id == %@", key)
        let one = try? storage.fetch(predicate: p, sortDescriptors: nil)?.first
        return one?.isTaken == true
    }

    func setIsTaken(on date: Date, _ value: Bool) throws {
        let key = date.toString(format: Supplement.dateFormat)
        let log = DailySupplementLog()
        log.id = key
        log.date = Calendar.current.startOfDay(for: date)
        log.isTaken = value
        try storage.save(log)
    }
}
