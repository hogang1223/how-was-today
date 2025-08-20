//
//  MemoFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct MemoFeature: DailyRecordFeature {
    var id = DailyRecordType.memo
    
    var title: String = "메모"
    
    var systemImageName: String = "pencil.and.scribble"
    
    var imageColor: Color = Color.orange
}
