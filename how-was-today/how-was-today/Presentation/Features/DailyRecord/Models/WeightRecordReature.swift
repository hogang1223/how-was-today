//
//  WeightRecordReature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct WeightFeature: DailyRecordFeature {
    var id = "weight"
    
    var title: String = "체중"
    
    var systemImageName: String = "scalemass.fill"
    
    var imageColor: Color = Color.blue
    
    var route: HowWasTodayRouter.Route?
    
    var modal: HowWasTodayRouter.Modal? = .weight
}
