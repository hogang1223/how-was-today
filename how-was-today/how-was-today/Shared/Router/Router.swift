//
//  Router.swift
//  how-was-today
//
//  Created by stocktong on 8/7/25.
//

import SwiftUI

// MARK: - Router Protocol

protocol Router: ObservableObject {
    associatedtype Route: Hashable
    associatedtype Content: View
    
    var path: NavigationPath { get set }
    
    func push(_ route: Route)
    func pop()
    func popToRoot()
    func replace(with route: Route)
    
    @ViewBuilder func view(for route: Route) -> Content
}

// MARK: - HowWasTodayRouter

final class HowWasTodayRouter: Router, ObservableObject {
    @Published var path = NavigationPath()
    
    enum Route: Hashable {
        case todaySummary
        case inputSupplement
    }
    
    // MARK: - Navigation Actions
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func replace(with route: Route) {
        path.removeLast()
        path.append(route)
    }
    
    // MARK: - View Factory
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .todaySummary:
            TodaySummaryView()
        case .inputSupplement:
            SupplementInputView()
        }
    }
}

// MARK: - RouterView (Generic Router Container)
struct RouterView<R: Router>: View {
    @StateObject private var router: R
    private let rootView: AnyView
    
    init(router: R, @ViewBuilder rootView: () -> some View) {
        self._router = StateObject(wrappedValue: router)
        self.rootView = AnyView(rootView())
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            rootView
                .environmentObject(router)
                .navigationDestination(for: R.Route.self) { route in
                    router.view(for: route)
                        .environmentObject(router)
                        .navigationBarHidden(true)
                }
        }
    }
}
