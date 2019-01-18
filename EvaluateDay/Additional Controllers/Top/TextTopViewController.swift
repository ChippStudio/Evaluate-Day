//
//  TextTopViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol TextTopViewControllerDelegate {
    @objc optional func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String)
}

class TextTopViewController: TopViewController, UITextViewDelegate {

    // MARK: - UI
    var textView: UITextView = UITextView()
    var titleLabel: UILabel = UILabel()
    var bottomView: UIView = UIView()
    
    // MARK: - Variable
    weak var delegate: TextTopViewControllerDelegate?
    
    var property: String = ""
    var onlyNumbers: Bool = false
    
    private var maxTextViewHeight: CGFloat = 100.0
    
//    private var heightConstraint
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Views
        self.titleLabel.textColor = UIColor.text
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        self.titleLabel.numberOfLines = 0
        
        self.textView.backgroundColor = UIColor.background
        self.textView.textColor = UIColor.main
        self.textView.font = UIFont.preferredFont(forTextStyle: .body)
        self.textView.tintColor = UIColor.main
        self.textView.delegate = self
        self.textView.inputAccessoryView = self.viewForTextView()
        if self.onlyNumbers {
            self.textView.keyboardType = .decimalPad
        }
        
        // Set constaraint
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.contentView.safeAreaLayoutGuide).offset(20.0)
            } else {
                make.top.equalTo(self.contentView).offset(40.0)
            }
            make.leading.equalTo(self.contentView).offset(10.0)
            make.trailing.equalTo(self.contentView).offset(-10.0)
        }
        
        self.contentView.addSubview(self.textView)
        self.textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.leading.equalTo(self.contentView).offset(10.0)
            make.trailing.equalTo(self.contentView).offset(-10.0)
            make.bottom.equalTo(self.contentView).offset(-20.0)
            make.height.equalTo(100.0)
        }
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textViewDidChange(self.textView)
    }
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !onlyNumbers || text.isEmpty {
            return true
        }
        
        if let separator = Locale.current.decimalSeparator {
            if text == separator {
                for i in textView.text {
                    if String(i) == separator {
                        return false
                    }
                }
                return true
            }
            
            let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            for i in numbers {
                if i == text {
                    return true
                }
            }
        }
        
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Control text view height
        let rext = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        var newHeight: CGFloat = 100.0
        if rext.height > newHeight && rext.height < self.maxTextViewHeight {
            newHeight = rext.height
        } else if rext.height > self.maxTextViewHeight {
            newHeight = self.maxTextViewHeight
        }
        
        self.textView.snp.updateConstraints { (make) in
            make.height.equalTo(newHeight)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc func cancelButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonAction(sender: UIButton) {
        self.delegate?.textTopController?(controller: self, willCloseWith: self.textView.text, forProperty: self.property)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard actions
    @objc func keyboardWillShow(sender: Notification) {
        let height = (sender.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height
        
        self.maxTextViewHeight = self.view.frame.size.height - height - 150
    }
    
    // MARK: - Private func
    private func viewForTextView() -> UIView {
        let style = Themes.manager.topViewControllerStyle
        
        let keyboardView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 140.0, height: 44.0))
        keyboardView.backgroundColor = style.topViewColor
        
        let cancelButton = UIButton()
        let saveButton = UIButton()
        
        cancelButton.setTitleColor(UIColor.text, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: .touchUpInside)
        cancelButton.setTitle(Localizations.General.cancel, for: .normal)
        
        saveButton.setTitleColor(UIColor.text, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        saveButton.addTarget(self, action: #selector(saveButtonAction(sender:)), for: .touchUpInside)
        saveButton.setTitle(Localizations.General.save, for: .normal)
        
        keyboardView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20.0)
        }
        
        keyboardView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20.0)
        }
        
        return keyboardView
    }
}
