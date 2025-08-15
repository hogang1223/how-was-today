//
//  SupplementPlan.swift
//  how-was-today
//
//  Created by hogang on 8/10/25.
//

import RealmSwift
import Foundation

/// # SupplementPlan
/// - 사용자가 설정한 영양제 복용 계획을 저장하는 Realm 모델
/// - 시작일과 복용할 영양제 목록을 포함
/// - 동일한 날짜일 경우 update
///
/// ## Properties
/// - `id`: startDate의 String ( yyyy-MM-dd)
/// - `startDate`: 복용 계획 시작 날짜
/// - `supplements`: 복용할 영양제 이름 목록
final class SupplementPlan: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var startDate: Date
    @Persisted var names: List<String>
}


enum SupplementPlanFactory {
    static func make(id: String, supplements: [String]) -> SupplementPlan {
        let p = SupplementPlan()
        p.id = id
        p.names.removeAll()
        p.names.append(objectsIn: supplements)
        return p
    }
}
