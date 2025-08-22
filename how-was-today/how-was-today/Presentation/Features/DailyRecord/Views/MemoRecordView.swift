//
//  MemoRecordView.swift
//  how-was-today
//
//  Created by stocktong on 8/20/25.
//

import SwiftUI
import UIKit

struct MemoRecordView: View {
    
    @EnvironmentObject var router: HowWasTodayRouter
    @StateObject var viewModel: MemoRecordViewModel
    @FocusState private var isFocused: Bool
    
    @State private var textHeight: CGFloat = 44
    private let minHeight: CGFloat = 44
    
    init(date: Date, vmFactory: @escaping (Date) -> MemoRecordViewModel) {
        self._viewModel = StateObject(wrappedValue: vmFactory(date))
    }
    
    var body: some View {
        MemoUIKitContainer(
            text: $viewModel.memo,
            onSave: { newText in
                // 빈값이면 삭제, 아니면 저장
                if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    
                } else {
                    viewModel.save()
                }
                router.pop()
            },
            onReset: {
//                viewModel.reset()
            }
        )
        .appNavigationBar(title: "메모") {
            Button("초기화") { viewModel.reset() }
                .font(.subheadline)
                .foregroundColor(viewModel.disableReset ? .gray : .black)
                .disabled(viewModel.disableReset)
        }
    }
}

final class MemoViewController: UIViewController, UITextViewDelegate {
    
    var text: String = "" {
        didSet {
            if textView.text != text {
                textView.text = text
            }
        }
    }
    var onSave: ((String) -> Void)?
    var onReset: (() -> Void)?
    
    // MARK: UI
    private let stackView = UIStackView()
    private let textView = UITextView()
    private let saveButton = UIButton()
    
    // State
    private var isKeyboardVisible = false
    private let minTextViewHeight: CGFloat = 44
    private var maxTextViewHeight: CGFloat = 300
    
    // TextView 높이 제약조건 추가
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        
        // 키보드 show/hide → 저장 버튼 숨김/표시
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        // 초기 값 반영
        textView.text = text
        
        updateTextViewHeight()
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         // 화면 크기가 정해진 후 최대 높이 계산
         calculateMaxHeight()
     }
    
    private func setupLayout() {
        
        stackView.axis = .vertical
        stackView.spacing = 0.0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // TextView
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        textView.keyboardDismissMode = .interactive // 드래그로도 닫힘
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .main
        
        // 하단 저장 컨테이너 + 버튼
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .main
        saveButton.layer.cornerRadius = 12
        saveButton.layer.masksToBounds = true
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        let spacing = UIView()
        
        [textView, spacing, saveButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: minTextViewHeight)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20),
            
            textViewHeightConstraint,
            
            spacing.heightAnchor.constraint(greaterThanOrEqualToConstant: 20.0),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func calculateMaxHeight() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let stackViewPadding: CGFloat = 24 // top: 4 + bottom: 20
        let spacingHeight: CGFloat = 20 // spacing 최소 높이
        let saveButtonHeight: CGFloat = 50
        let buttonAdjustment = isKeyboardVisible ? 0 : saveButtonHeight
        let availableHeight = safeAreaHeight - stackViewPadding - spacingHeight - buttonAdjustment
        
        maxTextViewHeight = availableHeight // 키보드 있을 때는 더 보수적으로
        
        // 현재 TextView 높이가 새로운 최대값을 초과하면 조정
        updateTextViewHeight()
    }
    
    
    private func updateTextViewHeight() {
        // TextView의 내용에 맞는 높이 계산
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = max(minTextViewHeight, size.height)
        
        if newHeight <= maxTextViewHeight {
            // 최대 높이보다 작으면 스크롤 비활성화하고 높이 조정
            textView.isScrollEnabled = false
            textViewHeightConstraint.constant = newHeight
            
        } else {
            // 최대 높이에 도달하면 스크롤 활성화
            textView.isScrollEnabled = true
            textViewHeightConstraint.constant = maxTextViewHeight
        }
        
        // 부드러운 애니메이션
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func kbShow(_ n: Notification) {
        saveButton.isHidden = true
        isKeyboardVisible = true
        // 최대 높이 다시 계산
        calculateMaxHeight()
    }
    
    @objc private func kbHide(_ n: Notification) {
        saveButton.isHidden = false
        isKeyboardVisible = false
        // 최대 높이 다시 계산
        calculateMaxHeight()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapSave() {
        onSave?(textView.text ?? "")
    }
    
    // MARK: UITextViewDelegate
    func textViewDidChange(_ tv: UITextView) {
        text = tv.text
        updateTextViewHeight()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

struct MemoUIKitContainer: UIViewControllerRepresentable {
    @Binding var text: String
    var onSave: (String) -> Void
    var onReset: (() -> Void) = {}
    
    func makeUIViewController(context: Context) -> MemoViewController {
        let vc = MemoViewController()
        vc.text = text
        vc.onSave = { newText in
            onSave(newText)
        }
        vc.onReset = onReset
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MemoViewController, context: Context) {
        if uiViewController.text != text {
            uiViewController.text = text
        }
    }
}
