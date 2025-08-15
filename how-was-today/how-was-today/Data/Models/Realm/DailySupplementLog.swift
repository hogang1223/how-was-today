//
//  DailySupplementLog.swift
//  how-was-today
//
//  Created by hogang on 8/10/25.
//

import RealmSwift
import Foundation

/// # DailySupplementLog
/// - 사용자가 특정 날짜에 영양제를 복용했는지 기록하는 Realm 모델
/// - 하루에 1건만 저장되며, 복용 여부를 토글 가능
///
/// ## Properties
/// - `id`: date의 String ( yyyy-MM-dd)
/// - `date`: 기록 날짜
/// - `isTaken`: 해당 날짜에 복용했는지 여부 (true/false)
final class DailySupplementLog: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var isTaken: Bool
}

enum DailySupplementLogFactory {
    static func make(id: String, isTaken: Bool) -> DailySupplementLog {
        let p = DailySupplementLog()
        p.id = id
        p.isTaken = isTaken
        return p
    }
}
