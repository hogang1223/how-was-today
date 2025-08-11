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
    
    init(repositories: RepositoryContainer) {
        self.repositories = repositories
    }
    
    /// SupplementInput 화면 ViewModel 생성
    /// - Returns: `SupplementInputViewModel` 인스턴스
    func makeSupplementInputViewModel() -> SupplementInputViewModel {
        return SupplementInputViewModel(
            supplementRepo: repositories.supplementPlanRepository,
            userDefaultsStorage: UserDefaultsStorage.shared
        )
    }
}
