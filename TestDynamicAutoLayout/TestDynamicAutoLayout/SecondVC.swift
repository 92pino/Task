//
//  SecondVC.swift
//  TestDynamicAutoLayout
//
//  Created by hyeoktae kwon on 16/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class SecondVC: UIViewController {
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    private var indicatorViewLeadingConst: NSLayoutConstraint!
    
    private let wsNameTextField: UITextField = {
        let textField = UITextField()
        let attrString = NSAttributedString( // 어떤속성을 문자열에 적용
            string: "Name your workspace",
            attributes: [.foregroundColor: UIColor.darkText.withAlphaComponent(0.5)]
        )
        textField.attributedPlaceholder = attrString
        textField.font = UIFont.systemFont(ofSize: 22, weight: .light)
        textField.enablesReturnKeyAutomatically = true // 키보드 리턴키 동작안하게
        textField.borderStyle = .none
        textField.returnKeyType = .go // 키보드의 return을 go로 바꿈
        textField.autocorrectionType = .no // 자동완성 없앰
        textField.autocapitalizationType = .none // 첫문자 대문자로 하는거 없앰
        return textField
    }()
    
    private let floatingLabel: UILabel = {
        let l = UILabel()
        l.text = "Name your workspace"
        l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        l.alpha = 0
        return l
    }()
    private var floatingCenterYConst: NSLayoutConstraint!
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.blue, for: .selected)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let closeImage = UIImage(named: "btnClose")!
        button.setImage(closeImage, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wsNameTextField.becomeFirstResponder()
        
        
    }
    
    private func setupViews() {
        view.addSubview(nextButton)
        view.addSubview(closeButton)
        view.addSubview(wsNameTextField)
        view.addSubview(floatingLabel)
        view.addSubview(activityIndicatorView)
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        wsNameTextField.delegate = self
        
    }
    
    private func setupConstraints() {
        nextButton.layout.top().trailing(constant: -16)
        
        closeButton.layout
            .leading(constant: 16)
            .centerY(equalTo: nextButton.centerYAnchor)
        
        wsNameTextField.layout
            .leading(constant: 16)
            .trailing(constant: -16)
            .centerY(constant: -115)
        
        floatingLabel.layout
            .leading(equalTo: wsNameTextField.leadingAnchor)
        let defaultCenterYConst = floatingLabel.centerYAnchor
            .constraint(equalTo: wsNameTextField.centerYAnchor)
        defaultCenterYConst.priority = UILayoutPriority(500) // priority 적용
        defaultCenterYConst.isActive = true
        
        floatingCenterYConst = floatingLabel.centerYAnchor
            .constraint(equalTo: wsNameTextField.centerYAnchor, constant: -30)
        floatingCenterYConst.priority = .defaultLow
        floatingCenterYConst.isActive = true
        
        activityIndicatorView.layout.centerY(equalTo: wsNameTextField.centerYAnchor)
        
        indicatorViewLeadingConst = activityIndicatorView.leadingAnchor.constraint(equalTo: wsNameTextField.leadingAnchor)
        indicatorViewLeadingConst.isActive = true
    }
    
    private func vibration() {
        // kSystemSoundID_Vibrate  4095
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    @objc func didTapNextButton(_ sender: UIButton) {
        guard nextButton.isSelected, let text = wsNameTextField.text else { return vibration() }
        guard !activityIndicatorView.isAnimating else { return }
        
        let textSize = (text as NSString).size(withAttributes: [.font: wsNameTextField.font!])
        indicatorViewLeadingConst.constant = textSize.width + 8
        activityIndicatorView.startAnimating()
        let vc = ThirdVC()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityIndicatorView.stopAnimating()
            vc.wsNameTextField.text = text
            self.navigationController?.pushViewController(vc, animated: true)
            // 1, 다음 vc 띄우기
            // 2, text를 다음 뷰 컨트롤러에 넘기기 ...
        }
    }
    
    @objc func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true)
    }

}

extension SecondVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let replaceText = (text as NSString).replacingCharacters(in: range, with: string)
        nextButton.isSelected = !replaceText.isEmpty
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            if replaceText.isEmpty {
                self.floatingCenterYConst.priority = .defaultLow
                self.floatingLabel.alpha = 0.0
            } else {
                self.floatingCenterYConst.priority = .defaultHigh
                self.floatingLabel.alpha = 1.0
            }
            
            // false - layout 에 대한 변화가 필요 ㄴㄴ
            // true - layout 에 대한 변화가 필요 ㅇㅇ
            self.view.setNeedsLayout() // true, false
            
            self.view.layoutIfNeeded() // 즉시 변경된 layout 적용하라
        })
        
        return true
    }
}
