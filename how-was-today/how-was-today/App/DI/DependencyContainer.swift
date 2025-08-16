//
//  DependencyContainer.swift
//  how-was-today
//
//  Created by stocktong on 8/11/25.
//

/// # DependencyContainer
/// - 화면(ViewModel) 생성을 위한 의존성 주입(Dependency Injection) 인터페이스
/// - 각 화면에서 필요한 의존성을 주입하여 ViewModel을 생성하는 역할
protocol DependencyContainer {
    // MARK: - ViewModel
    func makeTodaySummaryViewModel() -> TodaySummaryViewModel
    /// SupplementInput 화면에서 사용할 ViewModel 생성
    func makeSupplementInputViewModel() -> SupplementInputViewModel
    
    // MARK: - UseCase
    func makeSupplementUseCaseFactory() -> SupplementUseCaseFactory
}
