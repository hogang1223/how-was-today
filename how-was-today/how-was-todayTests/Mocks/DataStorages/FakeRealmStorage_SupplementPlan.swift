//
//  FakeRealmStorage_SupplementPlan.swift
//  how-was-today
//
//  Created by hogang on 8/12/25.
//

import Foundation
@testable import how_was_today

/// RealmStorage<SupplementPlan>을 대체하는 테스트용 Fake.
/// 메모리에 SupplementPlan을 저장/조회합니다.
final class FakeRealmStorage_SupplementPlan {

    // In-memory 저장소 (id를 key로 관리)
    private var store: [String: SupplementPlan] = [:]

    // 테스트 검증용 캡처
    private(set) var lastFetchPredicate: NSPredicate?
    private(set) var lastFetchSortDescriptors: [NSSortDescriptor]?
    private(set) var saveCalledCount: Int = 0

    /// 편의: (id, [supplements]) 리스트로 시드 주입
    @discardableResult
    func seed(_ items: [(String, [String])]) -> Self {
        for (id, list) in items {
            let p = SupplementPlanFactory.make(id: id, supplements: list)
            store[id] = p
        }
        return self
    }
}

// MARK: - RealmStorage<SupplementPlan>과 유사한 인터페이스 흉내

extension FakeRealmStorage_SupplementPlan: DataStorage {
    
    /// RepoImpl에서 쓰는 형태를 흉내냅니다.
    /// - Returns: 조건/정렬에 맞는 배열. 없으면 빈 배열.
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [SupplementPlan]? {
        lastFetchPredicate = predicate
        lastFetchSortDescriptors = sortDescriptors

        var items = Array(store.values)
        
        if let idLimit = extractIdLimit(from: predicate) {
            items = items.filter { $0.id <= idLimit }
        }

        if let sort = sortDescriptors, !sort.isEmpty {
            items = (items as NSArray).sortedArray(using: sort) as! [SupplementPlan]
        } else {
            items.sort { $0.id > $1.id }
        }

        return items
    }
    

    /// 동일 id는 upsert로 가정
    func save(_ object: SupplementPlan) throws {
        saveCalledCount += 1
        store[object.id] = object
    }

    // 테스트 편의: 현재 저장 상태 조회
    func snapshot() -> [SupplementPlan] {
        Array(store.values)
    }
    
    func delete(_ object: SupplementPlan) throws {
    }
}

// NSPredicate helper
private extension FakeRealmStorage_SupplementPlan {
    /// NSPredicate가 `id <= "yyyy-MM-dd"` 형태일 때 우변 상수를 추출
    func extractIdLimit(from predicate: NSPredicate?) -> String? {
        guard let comp = predicate as? NSComparisonPredicate else { return nil }
        guard comp.predicateOperatorType == .lessThanOrEqualTo else { return nil }
        return comp.rightExpression.constantValue as? String
    }
}
