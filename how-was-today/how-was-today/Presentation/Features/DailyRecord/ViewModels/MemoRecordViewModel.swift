//
//  MemoRecordViewModel.swift
//  how-was-today
//
//  Created by stocktong on 8/20/25.
//

import Foundation

final class MemoRecordViewModel: ObservableObject {
    
    let date: Date
    @Published var memo: String = ""
    private var original: String = ""
    
    var disableReset: Bool {
        memo.isEmpty
    }
    
    init(date: Date) {
        self.date = date
    }
    
    func reset() {
        memo = ""
    }
    
    func refresh() {
        
    }
    
    func save() {
        let trimmed = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            delete()
        } else {
            // save
        }
    }
    
    func delete() {
    }
    
    func isMemoChanged() -> Bool {
        let trimmed = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed != original
    }
}
