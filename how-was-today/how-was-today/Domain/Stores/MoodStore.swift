//
//  MoodStore.swift
//  how-was-today
//
//  Created by stocktong on 8/19/25.
//

import Foundation

final class MoodStore: ObservableObject, DailyRecordStore {
    
    typealias T = Mood
    
    @Published var itemByDate: [String: Mood] = [:]
    
    private let repo: DailyMoodLogRepository
    
    init(repo: DailyMoodLogRepository) {
        self.repo = repo
    }
    
    func refresh(date: Date) {
        if let mood = repo.fetchMood(on: date) {
            itemByDate[key(from: date)] = mood
        }
    }
    
    func save(_ mood: Mood, on date: Date) {
        do {
            try repo.saveMood(on: date, mood)
            itemByDate[key(from: date)] = mood
        } catch {
            print("save mood error \(error.localizedDescription)")
        }
    }
    
    func delete(on date: Date) {
        do {
            try repo.deleteMood(on: date)
            itemByDate.removeValue(forKey: key(from: date))
        } catch {
            print("delete mood error \(error.localizedDescription)")
        }
    }
}
