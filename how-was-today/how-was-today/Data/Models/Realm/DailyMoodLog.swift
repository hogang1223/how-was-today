//
//  DailyMoodLog.swift
//  how-was-today
//
//  Created by stocktong on 8/18/25.
//

import RealmSwift
import Foundation

final class DailyMoodLog: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var mood: String // Mood의 rawValue
}
