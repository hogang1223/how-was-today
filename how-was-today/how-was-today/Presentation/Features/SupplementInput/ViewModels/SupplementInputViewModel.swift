//
//  SupplementInputViewModel.swift
//  how-was-today
//
//  Created by stocktong on 8/8/25.
//

import Foundation
import Combine

/// # SupplementInputViewModel
/// - SupplementInput 화면의 상태와 동작을 관리하는 뷰모델
/// - 영양제 복용 계획 조회/저장 로직을 포함
///
/// ## Responsibilities
/// - 현재 날짜 기준 복용 계획 로드 (`loadSupplements`)
/// - 사용자가 입력한 영양제 목록과 알람 설정 상태 관리
/// - 입력값 초기화 및 저장 처리
///
/// ## Properties
/// - `supplements`: 영양제 이름 목록 (빈 칸 포함)
/// - `alarmEnabled`: 알람 설정 여부
/// - `alarmTime`: 알람 시간
///
/// ## Public Methods
/// - `reset()`: 현재 입력값 초기화
/// - `save()`: 영양제 복용 계획 저장
/// - `addNewSupplements()`: 입력 칸 추가
///
/// ## Private Methods
/// - `loadSupplements()`: 저장된 복용 계획 불러오기 (부족 시 빈 칸 채움)
final class SupplementInputViewModel: ObservableObject {
    
    /// UI에서 기본적으로 보여줄 영양제 입력 칸 개수
    private let defaultSupplementCount = 3
    
    @Published var supplements: [String]
    
    // FIXME: 알림 관련 로직 개발 필요 (UserDefaults기반으로)
    @Published var alarmEnabled: Bool
    @Published var alarmTime: Date?
    
    private let supplementRepo: SupplementPlanRepository
    
    init(supplementRepo: SupplementPlanRepository) {
        self.supplementRepo = supplementRepo
        self.supplements = []
        self.alarmEnabled = false
        
        loadSupplements()
    }
    
    /// 모든 입력값이 초기 상태이면 Reset 버튼 비활성화
    var disableReset: Bool {
        supplements.allSatisfy {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        && !alarmEnabled
        && alarmTime == nil
    }
    
    /// 영양제 입력값과 알람 설정을 초기 상태로 되돌림
    func reset() {
        let currentSupplementsCount = supplements.count
        supplements = Array(repeating: "", count: currentSupplementsCount)
        alarmEnabled = false
        alarmTime = nil
    }
    
    /// 현재 입력값을 영양제 복용 계획으로 저장
    func save() {
        let nonEmptySupplements = supplements
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let supplementInfo = Supplement(date: Date(), names: nonEmptySupplements)
        do {
            try supplementRepo.savePlan(supplementInfo)
        } catch {
            print("영양제 기록 저장 실패 \(error.localizedDescription)")
        }
    }
    
    /// 영양제 입력 칸 하나 추가
    func addNewSupplements() {
        supplements.append("")
    }
}

extension SupplementInputViewModel {
    
    /// 저장된 복용 계획 불러오기
    /// - 부족한 입력 칸은 빈 문자열로 채움
    private func loadSupplements() {
        let supplementInfo = supplementRepo.fetchPlan(date: Date())
        var newSupplements = supplementInfo.names
        while newSupplements.count < defaultSupplementCount {
            newSupplements.append("")
        }
        supplements = newSupplements
    }
}
