//
//  DailyWeightLog.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation
import RealmSwift

/// # DailyWeightLog
/// - 사용자가 특정 날짜의 체중을 기록하는 Realm 모델
/// - 하루에 1건만 저장
///
/// ## Properties
/// - `id`: date의 String ( yyyy-MM-dd)
/// - `date`: 기록 날짜
/// - `weight`: 체중
final class DailyWeightLog: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var weight: Double
}
