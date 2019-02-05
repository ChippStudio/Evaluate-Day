//
//  TextViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol TextViewControllerDelegate {
    @objc optional func textTopController(controller: TextViewController, willCloseWith text: String, forProperty property: String)
}

class TextViewController: UIViewController, UITextViewDelegate {

    // MARK: - UI
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var maskView: UIView!

    // MARK: - Variable
    weak var delegate: TextViewControllerDelegate?
    
    var property: String = ""
    var text: String? = ""
    var titleText: String? = ""
    var onlyNumbers: Bool = false
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .overFullScreen
        self.transition = TextControllerTransition(animationDuration: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.modalPresentationStyle = .overFullScreen
        self.transition = TextControllerTransition(animationDuration: 0.4)
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Views
        self.titleLabel.textColor = UIColor.text
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.text = self.titleText
        
        self.textView.backgroundColor = UIColor.background
        self.textView.text = self.text
        self.textView.textColor = UIColor.main
        self.textView.font = UIFont.preferredFont(forTextStyle: .body)
        self.textView.tintColor = UIColor.main
        self.textView.delegate = self
        self.textView.inputAccessoryView = self.viewForTextView()
        self.textView.alwaysBounceVertical = true
        if self.onlyNumbers {
            self.textView.keyboardType = .decimalPad
        }
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.backgroundColor = UIColor.background
        
        self.maskView.backgroundColor = UIColor.main
        self.maskView.alpha = 0.6
        
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
        self.textView.contentInset.bottom = height
    }
    
    private func viewForTextView() -> UIView {
        
        let keyboardView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 140.0, height: 44.0))
        keyboardView.backgroundColor = UIColor.background
        
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
            if #available(iOS 11.0, *) {
                make.leading.equalTo(keyboardView.safeAreaLayoutGuide).offset(20.0)
            } else {
                // Fallback on earlier versions
                make.leading.equalToSuperview().offset(20.0)
            }
        }
        
        keyboardView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.trailing.equalTo(keyboardView.safeAreaLayoutGuide).offset(-20.0)
            } else {
                // Fallback on earlier versions
                make.trailing.equalToSuperview().offset(-20.0)
            }
        }
        
        return keyboardView
    }
}
