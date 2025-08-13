//
//  SupplementAlarm.swift
//  how-was-today
//
//  Created by hogang on 8/10/25.
//

import RealmSwift
import Foundation

/// # SupplementAlarm
/// - 영양제 알람 설정을 저장하는 Realm 모델
/// - 앱에서 1개의 레코드만 유지(싱글톤 데이터)하여 알람 상태를 관리
///
/// ## Properties
/// - `isAlarmOn`: 알람 활성화 여부 (true = 켜짐, false = 꺼짐)
/// - `alarmTime`: 알람 시간
final class SupplementAlarm: Object {
    @Persisted var isAlarmOn: Bool
    @Persisted var alarmTime: Date
}
