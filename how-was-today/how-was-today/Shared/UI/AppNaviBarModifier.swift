//
//  AppNaviBarModifier.swift
//  how-was-today
//
//  Created by hogang on 8/12/25.
//

import SwiftUI

// 공통 네비게이션 바 스타일 모디파이어
// - 모든 화면에서 동일한 NavigationBar UI/구조를 재사용 가능
// - 타이틀, 백버튼 표시 여부, 백버튼 동작, 오른쪽 버튼 그룹을 화면별로 주입 가능
struct AppNavBarModifier<Trailing: View>: ViewModifier {
    let title: String
    var showBack: Bool = true
    var onBack: (() -> Void)?
    @ViewBuilder var trailing: () -> Trailing

    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            // 네비 타이틀 및 표시 모드
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)

            // 네비게이션 바 배경/경계선 설정
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)

            // 커스텀 툴바 구성
            .toolbar {
                if showBack {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            (onBack ?? { dismiss() })()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    trailing()
                }
            }
    }
}

extension View {
    /// trailing 버튼이 있는 버전
    func appNavigationBar<T: View>(
        title: String,
        showBack: Bool = true,
        onBack: (() -> Void)? = nil,
        @ViewBuilder trailing: @escaping () -> T
    ) -> some View {
        modifier(
            AppNavBarModifier(
                title: title,
                showBack: showBack,
                onBack: onBack,
                trailing: trailing
            ))
    }

    /// trailing 버튼이 없는 기본 버전
    func appNavigationBar(
        title: String,
        showBack: Bool = true,
        onBack: (() -> Void)? = nil
    ) -> some View {
        modifier(
            AppNavBarModifier(
                title: title,
                showBack: showBack,
                onBack: onBack,
                trailing: { EmptyView() }
            ))
    }
}
