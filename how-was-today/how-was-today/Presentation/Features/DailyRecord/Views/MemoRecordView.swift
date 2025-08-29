import SwiftUI
import UIKit

// MARK: - SwiftUI Entry

struct MemoRecordView: View {
    @EnvironmentObject var router: HowWasTodayRouter
    @StateObject private var viewModel: MemoRecordViewModel<MemoStore>
    
    @State private var showLeaveAlert = false

    init(date: Date, vmFactory: @escaping (Date) -> MemoRecordViewModel<MemoStore>) {
        _viewModel = StateObject(wrappedValue: vmFactory(date))
    }

    var body: some View {
        MemoUIKitContainer(
            text: $viewModel.memo,
            onSave: { newText in
                viewModel.memo = newText
                viewModel.save()
                router.pop()
            },
            onReset: { viewModel.reset() }
        )
        .onAppear { viewModel.refresh() }
        .alert("변경된 내용이 있어요.\n저장할까요?", isPresented: $showLeaveAlert) {
            Button("아니요", role: .cancel) {
                router.pop()
            }
            Button("저장하기", role: .none) {
                viewModel.save()
                router.pop()
            }
        }
        .appNavigationBar(title: "메모", onBack: {
            if viewModel.isMemoChanged() {
                showLeaveAlert = true
            }
        }, trailing: {
            Button("초기화") { viewModel.reset() }
                .font(.subheadline)
                .foregroundColor(viewModel.disableReset ? .gray : .black)
                .disabled(viewModel.disableReset)
        })
    }
}

// MARK: - UIKit VC

final class MemoViewController: UIViewController, UITextViewDelegate {
    
    private enum Metric {
        static let minTextViewHeight = 44.0
        static let maxTextViewHeight = 300.0
        static let textViewInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 8.0, right: 0)
        
        static let buttonRadius = 12.0
        static let buttonHeight = 50.0
        
        static let padding = 20.0
        static let topPadding = 4.0
    }

    // External API
    var text: String = "" {
        didSet { if textView.text != text { textView.text = text } }
    }
    var onSave: ((String) -> Void)?
    var onChange: ((String) -> Void)?
    var onReset: (() -> Void)?

    // UI
    private let stackView = UIStackView()
    private let textView = UITextView()
    private let saveButton = UIButton(type: .system)
    private var textViewHeightConstraint: NSLayoutConstraint!

    // State
    private var maxTextViewHeight: CGFloat = Metric.maxTextViewHeight
    private var isKeyboardVisible = false

    // Keyboard observers
    private var kbShowObserver: NSObjectProtocol?
    private var kbHideObserver: NSObjectProtocol?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        bindKeyboard()
        textView.text = text
    }

    deinit {
        if let o = kbShowObserver { NotificationCenter.default.removeObserver(o) }
        if let o = kbHideObserver { NotificationCenter.default.removeObserver(o) }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculateMaxHeight()
        updateTextViewHeight(animated: false) // 첫 레이아웃에서 폭 확정 후 계산
    }

    // MARK: Layout
    private func setupLayout() {
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // TEXTVIEW
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = Metric.textViewInset
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .main
        textView.isScrollEnabled = false

        // SAVE BUTTON
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .main
        saveButton.layer.cornerRadius = Metric.buttonRadius
        saveButton.layer.masksToBounds = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)

        // Flexible spacing
        let spacer = UIView()

        [textView, spacer, saveButton].forEach { stackView.addArrangedSubview($0) }

        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: Metric.minTextViewHeight)
        textViewHeightConstraint.isActive = true

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Metric.topPadding),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Metric.padding),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Metric.padding),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -Metric.padding),

            spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: Metric.padding),
            saveButton.heightAnchor.constraint(equalToConstant: Metric.buttonHeight)
        ])
    }

    private func calculateMaxHeight() {
        let safeH = view.safeAreaLayoutGuide.layoutFrame.height
        // top(4)+bottom(20)=24, spacer 최소 20, 버튼 50 (키보드 있을 땐 버튼 숨김)
        let chrome: CGFloat = Metric.topPadding + (Metric.padding * 2) + (isKeyboardVisible ? 0 : Metric.buttonHeight)
        let available = max(100, safeH - chrome) // 하한선 방어
        maxTextViewHeight = available
    }

    private func contentFittingHeight(for width: CGFloat) -> CGFloat {
        // 폭이 0일 수 있어 방어
        let w = max(1, width)
        let fitting = textView.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude))
        return max(Metric.minTextViewHeight, fitting.height)
    }

    private func updateTextViewHeight(animated: Bool = true) {
        let target = contentFittingHeight(for: textView.bounds.width)
        if target <= maxTextViewHeight {
            textView.isScrollEnabled = false
            textViewHeightConstraint.constant = target
        } else {
            textView.isScrollEnabled = true
            textViewHeightConstraint.constant = maxTextViewHeight
        }
        if animated {
            UIView.animate(withDuration: 0.1) { self.view.layoutIfNeeded() }
        } else {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: Keyboard
    private func bindKeyboard() {
        kbShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            isKeyboardVisible = true
            saveButton.isHidden = true
            calculateMaxHeight()
            updateTextViewHeight()
        }

        kbHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            isKeyboardVisible = false
            saveButton.isHidden = false
            calculateMaxHeight()
            updateTextViewHeight()
        }
    }

    // MARK: Actions
    @objc private func didTapSave() {
        onSave?(textView.text)
    }

    // MARK: UITextViewDelegate
    func textViewDidChange(_ tv: UITextView) {
        text = tv.text
        onChange?(tv.text)
        updateTextViewHeight()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - SwiftUI Bridge

struct MemoUIKitContainer: UIViewControllerRepresentable {
    
    @Binding var text: String
    var onSave: (String) -> Void
    var onReset: () -> Void = {}
    
    final class Coordinator {
        var text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        func textChanged(_ new: String) {
            if text.wrappedValue != new {
                text.wrappedValue = new   // ← SwiftUI State/VM로 반영
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeUIViewController(context: Context) -> MemoViewController {
        let vc = MemoViewController()
        vc.text = text
        vc.onSave = { [weak vc] newText in
            onSave(newText)
            // (선택) 저장 후 키보드 닫기/해제
            vc?.view.endEditing(true)
        }
        vc.onReset = { [weak vc] in
            onReset()
            vc?.text = ""
            vc?.view.endEditing(true)
        }
        vc.onChange = { context.coordinator.textChanged($0) }
        return vc
    }

    func updateUIViewController(_ uiViewController: MemoViewController, context: Context) {
        if uiViewController.text != text {
            uiViewController.text = text
        }
    }
}
