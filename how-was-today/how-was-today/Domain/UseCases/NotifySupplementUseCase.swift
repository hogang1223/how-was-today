//
//  NotifySupplementUseCase.swift
//  how-was-today
//
//  Created by stocktong on 8/11/25.
//

import Foundation

protocol NotifySupplementUseCase {
    func getAlarmTime() -> TimeOfDay?
    func saveAlarmTime(_ time: TimeOfDay)
}

struct NotifySupplementUseCaseImpl: NotifySupplementUseCase {
    
    private let userDefaults: KeyValueDataStorage
    private let alarmTimeKey = UserDefaultsStorage.Keys.supplementAlarmMinutes
    
    init(userDefaults: KeyValueDataStorage) {
        self.userDefaults = userDefaults
    }
    
    func getAlarmTime() -> TimeOfDay? {
        guard let time = userDefaults.getValue(
            forKey: alarmTimeKey,
            as: Int.self
        ) else { return nil }
        return TimeOfDay(minutesSinceMidnight: time)
    }
    
    func saveAlarmTime(_ time: TimeOfDay) {
        try? userDefaults.setValue(time.minutesSinceMidnight, forKey: alarmTimeKey)
    }
}
