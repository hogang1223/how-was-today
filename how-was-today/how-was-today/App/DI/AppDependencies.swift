//
//  AppDependencies.swift
//  how-was-today
//
//  Created by stocktong on 8/11/25.
//

import Foundation

/// # AppDependencies
/// - 앱 전체에서 사용할 실제 의존성 주입 컨테이너 구현체
/// - `RepositoryContainer`를 통해 각종 Repository를 주입받아 ViewModel을 생성
///
/// ## Responsibilities
/// - 의존성 객체 생성 및 관리
/// - 필요한 의존성을 주입하여 ViewModel 인스턴스를 반환
final class AppDependencies: DependencyContainer {
    
    /// 앱 전역에서 사용하는 Repository 모음
    private let repositories: RepositoryContainer
    
    ///
    lazy var weightStore: WeightStore = WeightStore(repo: repositories.dailyWeightRepository)
    
    init(repositories: RepositoryContainer) {
        self.repositories = repositories
    }
}

// MARK: - ViewModels

extension AppDependencies {
    
    /// TodaySummaryView ViewModel 생성
    func makeTodaySummaryViewModel() -> TodaySummaryViewModel {
        return TodaySummaryViewModel(
            factory: makeSupplementUseCaseFactory(),
            weightStore: weightStore
        )
    }
    
    /// SupplementInputView ViewModel 생성
    func makeSupplementInputViewModel() -> SupplementInputViewModel {
        return SupplementInputViewModel(supplementRepo: repositories.supplementPlanRepository)
    }
    
    func makeWeightRecordViewModel(date: Date) -> WeightRecordBottomSheetViewModel {
        return WeightRecordBottomSheetViewModel(date: date, store: weightStore)
    }
}

// MARK: - UseCases

extension AppDependencies {
    
    func makeSupplementUseCaseFactory() -> SupplementUseCaseFactory {
        return SupplementUseCaseFactory(
            makeFetch: {
                FetchSupplementUseCaseImpl(
                    planRepo: self.repositories.supplementPlanRepository,
                    logRepo: self.repositories.dailySupplementRepository
                )
            },
            makeToggle: {
                ToggleSupplementTakenUseCaseImpl(
                    logRepo: self.repositories.dailySupplementRepository
                )
            }
        )
    }
}
