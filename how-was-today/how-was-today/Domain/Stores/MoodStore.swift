//
//  MoodStore.swift
//  how-was-today
//
//  Created by stocktong on 8/19/25.
//

import Foundation

final class MoodStore: ObservableObject {
    
    @Published private(set) var itemByDate: [String: Mood] = [:]
    
    private let repo: DailyMoodLogRepository
    
    init(repo: DailyMoodLogRepository) {
        self.repo = repo
    }
    
    func refresh(date: Date) {
        if let mood = repo.fetchMood(on: date) {
            itemByDate[id(from: date)] = mood
        }
    }
    
    func save(_ mood: Mood, on date: Date) {
        do {
            try repo.saveMood(on: date, mood)
            itemByDate[id(from: date)] = mood
        } catch {
            print("save mood error \(error.localizedDescription)")
        }
    }
    
    func mood(on date: Date) -> Mood? {
        itemByDate[id(from: date)]
    }
    
    func delete(on date: Date) {
        do {
            try repo.deleteMood(on: date)
            itemByDate.removeValue(forKey: id(from: date))
        } catch {
            print("delete mood error \(error.localizedDescription)")
        }
    }
    
    private func id(from date: Date) -> String {
        date.toString(format: DailyRecord.dateFormat)
    }
}
