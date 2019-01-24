//
//  OnChatTextActionView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

public class OnChatTextActionView: UIView, ActionView, UITextFieldDelegate {
    
    public var complition: ((String) -> Void)?
    
    // MARK: - UI
    public var button = UIButton()
    public var textField = UITextField()
    
    // MARK: - Variables
    public let skipString: String
    public let sendString: String
    
    // MARK: - Init
    public init(skipTitle: String, sendTitle: String) {
        self.skipString = skipTitle
        self.sendString = sendTitle
        
        super.init(frame: CGRect.zero)
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        
        self.backgroundColor = UIColor.white
        // Set text field
        self.textField.borderStyle = .roundedRect
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.returnKeyType = .done
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(self.textFieldAction(sender:)), for: .editingChanged)
        
        // set button
        self.button.setTitle(self.skipString, for: .normal)
        self.button.setTitleColor(UIColor.black, for: .normal)
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTarget(self, action: #selector(self.buttonAction(sendre:)), for: .touchUpInside)
        
        // Set all views
        self.addSubview(self.button)
        self.addSubview(self.textField)
        
        let tTopConstraint = NSLayoutConstraint(item: self.textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10.0)
        let tBottomConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            tBottomConstraint = NSLayoutConstraint(item: self.textField, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        } else {
            tBottomConstraint = NSLayoutConstraint(item: self.textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        }
        let tLeadingConstraint = NSLayoutConstraint(item: self.textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 20.0)

        let bCenterConstraint = NSLayoutConstraint(item: self.button, attribute: .centerY, relatedBy: .equal, toItem: self.textField, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let bHeightConstraint = NSLayoutConstraint(item: self.button, attribute: .height, relatedBy: .equal, toItem: self.textField, attribute: .height, multiplier: 1.0, constant: 0.0)
        let bLeadingConstraint = NSLayoutConstraint(item: self.button, attribute: .leading, relatedBy: .equal, toItem: self.textField, attribute: .trailing, multiplier: 1.0, constant: 20.0)
        let bTrailingConstraint = NSLayoutConstraint(item: self.button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -20.0)

        self.button.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        self.textField.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        
        self.addConstraints([bCenterConstraint, bHeightConstraint, bTrailingConstraint, bLeadingConstraint, tTopConstraint, tBottomConstraint, tLeadingConstraint])
    }
    
    @objc func buttonAction(sendre: UIButton) {
        if let text = self.textField.text {
            self.complition?(text)
        } else {
            self.complition?("")
        }
    }
    
    // MARK: - UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.buttonAction(sendre: self.button)
        
        return true
    }
    
    @objc func textFieldAction(sender: UITextField) {
        if sender.text == nil {
            self.button.setTitle(self.skipString, for: .normal)
            return
        }
        if sender.text!.isEmpty {
            self.button.setTitle(self.skipString, for: .normal)
        } else {
            self.button.setTitle(self.sendString, for: .normal)
        }
    }
}
