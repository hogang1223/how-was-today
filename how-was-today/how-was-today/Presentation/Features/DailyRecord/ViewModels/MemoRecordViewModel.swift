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
    
    var disableReset: Bool {
        memo.isEmpty
    }
    
    init(date: Date) {
        self.date = date
    }
    
    func reset() {
        memo = ""
    }
    
    func save() {
    }
}
