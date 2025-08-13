//
//  DateFormatter+Date.swift
//  how-was-today
//
//  Created by hogang on 8/10/25.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter(format: format)
        return formatter.string(from: self)
    }
}
