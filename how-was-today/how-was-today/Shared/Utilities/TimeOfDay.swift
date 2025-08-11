//
//  TimeOfDay.swift
//  how-was-today
//
//  Created by stocktong on 8/11/25.
//

import Foundation

struct TimeOfDay: Equatable, Codable {
    let hour: Int
    let minute: Int
}

extension TimeOfDay {
    static func from(date: Date, calendar: Calendar = .current) -> TimeOfDay {
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        return TimeOfDay(hour: comps.hour ?? 0, minute: comps.minute ?? 0)
    }

    func date(on day: Date = Date(), calendar: Calendar = .current) -> Date {
        var comps = calendar.dateComponents([.year, .month, .day], from: day)
        comps.hour = hour
        comps.minute = minute
        return calendar.date(from: comps) ?? day
    }
    
    func localizedTimeString(locale: Locale = .autoupdatingCurrent) -> String {
        let d = date()
        let style = Date.FormatStyle(date: .omitted, time: .shortened).locale(locale)
        return d.formatted(style)
    }
}

extension TimeOfDay {
    
    var minutesSinceMidnight: Int { hour * 60 + minute }

    init(minutesSinceMidnight m: Int) {
        let mm = ((m % 1440) + 1440) % 1440 // 안전 보정
        self.hour = mm / 60
        self.minute = mm % 60
    }
}
