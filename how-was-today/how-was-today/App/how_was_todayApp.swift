//
//  how_was_todayApp.swift
//  how-was-today
//
//  Created by hogang on 8/3/25.
//

import SwiftUI

@main
struct how_was_todayApp: App {
    var body: some Scene {
        WindowGroup {
            let repositories = RepositoryContainer()
            let dependencies = AppDependencies(repositories: repositories)
            RouterView(router: HowWasTodayRouter(dependencies: dependencies)) {
                TodaySummaryView()
            }
        }
    }
}
