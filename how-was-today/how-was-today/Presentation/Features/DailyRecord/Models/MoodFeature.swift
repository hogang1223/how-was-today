//
//  MoodFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct MoodFeature: DailyRecordFeature {
    var id = DailyRecordType.mood
    
    var title: String = "기분"
    
    var systemImageName: String = "face.smiling.inverse"
    
    var imageColor: Color = Color.yellow
    
    func getModal(date: Date) -> HowWasTodayRouter.Modal? {
        .mood(date: date)
    }
}

enum Mood: String, CaseIterable, Identifiable {
    case fun = "꿀잼🤩"
    case boring = "노잼😑"
    case healing = "힐링🍵타임"
    case realityCheck = "현타🤯"
    case blank = "멍~😶때리기"
    case proud = "뿌듯💪(오운완)"
    case heartBeat = "심쿵💖>_<"
    case angry = "빡침🤬xxx"
    case tired = "개피곤🥱"
    
    var id: String { rawValue }
}
