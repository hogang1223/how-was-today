//
//  MoodFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct MoodFeature: DailyRecordFeature {
    var id = DailyRecord.mood
    
    var title: String = "기분"
    
    var systemImageName: String = "face.smiling.inverse"
    
    var imageColor: Color = Color.yellow
    
    var route: HowWasTodayRouter.Route?
    
    var modal: HowWasTodayRouter.Modal?
}
