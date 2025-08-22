//
//  DailyConditionLog.swift
//  how-was-today
//
//  Created by hogang on 8/20/25.
//

import RealmSwift
import Foundation

final class DailyConditionLog: Object {
    @Persisted(primaryKey: true) var id: String // yyyy-MM-dd
    @Persisted var date: Date
    @Persisted var selections: List<DailyConditionSelection>
}

final class DailyConditionSelection: EmbeddedObject {
    @Persisted var optionId: String
    @Persisted var category: String // ConditionType.rawValue
}
  
