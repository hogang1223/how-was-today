//
//  Router.swift
//  how-was-today
//
//  Created by stocktong on 8/7/25.
//

import SwiftUI

/// # Router
/// - NavigationStack 기반의 화면 전환을 추상화하는 프로토콜
/// - 화면 식별을 위한 `Route` 타입과, 해당 Route에 대응하는 `View`를 생성하는 역할
///
/// ## Associated Types
/// - `Route`: 화면 전환 대상 식별 값 (enum 사용 권장)
/// - `Content`: 각 Route에 대응하는 SwiftUI View 타입
///
/// ## Responsibilities
/// - push/pop/popToRoot/replace: 화면 이동 액션 제공
/// - view(for:): 특정 Route에 대응하는 View 생성
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

protocol ModalRouter: Router {
    associatedtype Modal: Identifiable
    var modal: Modal? { get set }
    
    func present(_ modal: Modal)
    func dismissModal()
    func modalView(for modal: Modal) -> AnyView
}


/// # HowWasTodayRouter
/// - `how-was-today` 앱의 전역 라우터 구현체
/// - 화면 전환에 필요한 ViewModel 및 View는 `DependencyContainer`를 통해 주입
///
/// ## Route Cases
/// - `.todaySummary`: 오늘 하루 요약 화면
/// - `.inputSupplement`: 영양제 입력 화면
///
/// ## Notes
/// - `dependencies`를 통해 필요한 ViewModel Factory를 호출하여 View에 전달
final class HowWasTodayRouter: ObservableObject {
    
    enum Route: Hashable {
        case todaySummary
        case inputSupplement
    }
    
    enum Modal: String, Identifiable {
        case dailyRecord
        case weight
        
        var id: String { self.rawValue }
    }
    
    @Published var path = NavigationPath()
    @Published var modal: Modal?

    private let dependencies: DependencyContainer
    
    init(dependencies: DependencyContainer) {
        self.dependencies = dependencies
    }
}

extension HowWasTodayRouter: Router {
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
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .todaySummary:
            TodaySummaryView(viewModelFactory: self.dependencies.makeTodaySummaryViewModel)
        case .inputSupplement:
            SupplementInputView(viewModelFactory: dependencies.makeSupplementInputViewModel)
        }
    }
}

extension HowWasTodayRouter: ModalRouter {
    
    func present(_ modal: Modal) {
        self.modal = modal
        print(modal.id)
    }
    
    func dismissModal() {
        self.modal = nil
    }
    
    func modalView(for modal: Modal) -> AnyView {
        switch modal {
        case .dailyRecord:
            return AnyView(DailyRecordBottomSheet())
        case .weight:
            return AnyView(WeightRecordBottomSheet()
            )
        }
    }
}

/// # RouterView
/// - 특정 Router 구현체를 감싸는 제네릭 네비게이션 컨테이너
/// - NavigationStack과 Router를 결합하여 화면 전환 로직을 단일 지점에서 처리
///
/// ## Parameters
/// - `router`: 사용할 Router 구현체
/// - `rootView`: 첫 화면으로 표시할 View
///
/// ## Notes
/// - `environmentObject(router)`를 사용하여 하위 View에서 Router 액션 호출 가능
/// - `navigationDestination(for:)`를 통해 Route 기반 화면 전환 처리
struct RouterView<R: Router>: View {
    @StateObject private var router: R
    private let rootView: AnyView
    
    init(router: R, @ViewBuilder rootView: () -> some View) {
        self._router = StateObject(wrappedValue: router)
        self.rootView = AnyView(rootView())
    }

    var body: some View {
        let stack = NavigationStack(path: $router.path) {
            rootView
                .environmentObject(router)
                .navigationDestination(for: R.Route.self) { route in
                    router.view(for: route)
                        .environmentObject(router)
                }
        }
        
        if let modalRouter = router as? HowWasTodayRouter {
            stack.sheet(item: Binding<HowWasTodayRouter.Modal?>(
                get: { modalRouter.modal },
                set: { modalRouter.modal = $0 }
            )) { modal in
                modalRouter.modalView(for: modal)
                    .presentationCornerRadius(BottomSheet.Metric.cornerRadius)
                    .environmentObject(modalRouter)
            }
        } else {
            stack
        }
    }
}
