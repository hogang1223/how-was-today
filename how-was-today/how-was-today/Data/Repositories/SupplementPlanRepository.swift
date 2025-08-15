//
//  SupplementPlanRepository.swift
//  how-was-today
//
//  Created by hogang on 8/10/25.
//

import Foundation

/// # SupplementPlanRepository
/// - 영양제 복용 계획 정보 조회/저장을 담당하는 추상 인터페이스
///
/// ## Methods
/// - `fetchPlan(date:)`:
///     지정된 날짜와 같거나 가장 가까운 과거 날짜의 복용 계획을 조회.
///     - 계획이 없으면 빈 Supplement 반환
///     - 같은 날짜의 계획이 존재하면 해당 계획 반환
/// - `savePlan(_:)`:
///     복용 계획을 저장하거나 업데이트.
///     동일 id(yyyy-MM-dd) 계획이 이미 존재하면 교체(upsert) 처리
protocol SupplementPlanRepository {
    func fetchPlan(date: Date) -> Supplement
    func savePlan(_ supplement: Supplement) throws
}

final class SupplementPlanRepositoryImpl<
    Storage: DataStorage
>: SupplementPlanRepository where Storage.ObjectType == SupplementPlan {
    
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func fetchPlan(date: Date) -> Supplement {
        var supplement = Supplement(date: date, names: [])
        let id = date.toString(format: Supplement.dateFormat)
        let predicate = NSPredicate(format: "id <= %@", id)
        do {
            let data = try storage.fetch(
                predicate: predicate,
                sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)]
            )
            if let nearest = data?.first {
                supplement.names = Array(nearest.names)
            }
        } catch {
            print("fetch plan data error = \(error.localizedDescription)")
        }
        return supplement
    }
    
    func savePlan(_ supplement: Supplement) throws {
        guard let startDate = supplement.date else {
            return
        }
        
        let plan = SupplementPlan()
        plan.id = startDate.toString(format: Supplement.dateFormat)
        plan.startDate = startDate
        plan.names.append(objectsIn: supplement.names)
        try storage.save(plan)
    }
}
