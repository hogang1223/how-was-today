//
//  RepositoryContainer.swift
//  how-was-today
//
//  Created by stocktong on 8/11/25.
//

import Foundation

/// # RepositoryContainer
/// - 앱 전역에서 사용되는 모든 Repository 인스턴스를 보관하는 의존성 컨테이너
/// - 각 Repository는 필요한 시점에 지연 초기화(lazy) 방식으로 생성
///
/// ## Responsibilities
/// - 데이터 저장/조회 로직을 담당하는 Repository들을 중앙에서 관리
/// - 각 Repository 생성 시 필요한 Storage 구현체(Realm, UserDefaults 등)를 주입
///
/// ## Notes
/// - `lazy` 키워드를 사용하여 실제 사용 시점에 인스턴스 생성 → 불필요한 초기화 방지
final class RepositoryContainer {
    
    /// 영양제 복용 계획 저장/조회 Repository
    lazy var supplementPlanRepository: SupplementPlanRepository = SupplementPlanRepositoryImpl(
        storage: RealmStorage<SupplementPlan>()
    )
    
    lazy var dailySupplementRepository: DailySupplementLogRepository = DailySupplementLogRepositoryImpl(
        storage: RealmStorage<DailySupplementLog>()
    )
    
    lazy var dailyWeightRepository: DailyWeightLogRepository = DailyWeightLogRepositoryImpl(
        storage: RealmStorage<DailyWeightLog>()
    )
        
    lazy var dailyMoodRepository: DailyMoodLogRepository = DailyMoodLogRepositoryImpl(
        storage: RealmStorage<DailyMoodLog>()
    )
}
