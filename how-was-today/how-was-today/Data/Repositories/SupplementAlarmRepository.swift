//
//  SupplementAlarmRepository.swift
//  how-was-today
//
//  Created by hogang on 8/10/25.
//

import Foundation

/// # SupplementAlarmRepository
/// - 영양제 복용 알람 정보 저장을 담당하는 추상 인터페이스
///
/// ## Methods
/// - `updateAlarm(isOn: Bool, time: Date)`:
///     알람의 켜짐/꺼짐 상태와 알람 시간을 업데이트.
///     해당 정보는 없거나 1개만 존재.
protocol SupplementAlarmRepository {
    func updateAlarm(isOn: Bool, time: Date) throws
}

final class SupplementAlarmRepositoryImpl<
    Storage: DataStorage
>: SupplementAlarmRepository where Storage.ObjectType == SupplementAlarm {
    
    private let stroage: Storage
    
    init(stroage: Storage) {
        self.stroage = stroage
    }
    func updateAlarm(isOn: Bool, time: Date) throws {
        let alarm = SupplementAlarm()
        alarm.isAlarmOn = isOn
        alarm.alarmTime = time
        try stroage.save(alarm)
    }
}
