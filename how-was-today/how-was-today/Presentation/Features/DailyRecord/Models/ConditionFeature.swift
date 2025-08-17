//
//  ConditionFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct ConditionFeature: DailyRecordFeature {
    var id = "condition"
    
    var title: String = "몸 상태"
    
    var systemImageName: String = "figure.child"
    
    var imageColor: Color = Color.health
    
    var route: HowWasTodayRouter.Route?
    
    var modal: HowWasTodayRouter.Modal?
}
