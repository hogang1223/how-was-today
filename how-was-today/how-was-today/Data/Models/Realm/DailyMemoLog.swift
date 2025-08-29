//
//  DailyMemoLog.swift
//  how-was-today
//
//  Created by stocktong on 8/22/25.
//

import RealmSwift
import Foundation

final class DailyMemoLog: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var memo: String // Mood의 rawValue
}
