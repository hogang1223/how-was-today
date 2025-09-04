//
//  WeightStore.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation

final class WeightStore: ObservableObject, DailyRecordStore {
    
    typealias T = Double
    
    let defaultWeight = 50.0
    @Published var itemByDate: [String: Double] = [:]
    
    private let repo: DailyWeightLogRepository
    
    init(repo: DailyWeightLogRepository) {
        self.repo = repo
    }
    
    func refresh(date: Date) {
        if let w = repo.fetchWeight(on: date) {
            itemByDate[key(from: date)] = w
        }
    }
    
    func lastestWeight(date: Date) -> Double? {
        repo.fetchLastestWeight(on: date)
    }
    
    func save(_ weight: Double, on date: Date) {
        do {
            try repo.saveWeight(on: date, weight)
            itemByDate[key(from: date)] = weight
        } catch {
            print("save weight error \(error.localizedDescription)")
        }
    }
    
    func delete(on date: Date) {
        do {
            try repo.deleteWeight(on: date)
            itemByDate.removeValue(forKey: key(from: date))
        } catch {
            print("delete weight error \(error.localizedDescription)")
        }
    }
    
    func prefetch(center: Date, daysBefore: Int, daysAfter: Int) {
        let (start, end) = computeRange(
            center: center,
            daysBefore: daysBefore,
            daysAfter: daysAfter
         )

    }
}

extension Calendar {
    func dayKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.calendar = self
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: startOfDay(for: date))
    }
    func start(_ date: Date) -> Date { startOfDay(for: date) }
}

func computeRange(center: Date, daysBefore: Int, daysAfter: Int, cal: Calendar = .current) -> (Date, Date) {
    let s = cal.date(byAdding: .day, value: -daysBefore, to: cal.start(center))!
    let e = cal.date(byAdding: .day, value: daysAfter + 1, to: cal.start(center))! // exclusive
    return (s, e)
}
