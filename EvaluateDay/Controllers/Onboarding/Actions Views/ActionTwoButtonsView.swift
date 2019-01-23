//
//  ActionTwoButtonsView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class ActionTwoButtonsView: UIView, ActionView {
    
    // MARK: - UI
    var one = UIButton()
    var two = UIButton()
    
    // MARK: - Variables
    var complition: ((String) -> Void)?
    
    // MARK: - Override
    init() {
        super.init(frame: CGRect.zero)
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    // MARK: - Init subviews
    fileprivate func initSubviews() {
        // Custom initialization
        self.backgroundColor = UIColor.positive
        
        self.one.setTitleColor(UIColor.tint, for: .normal)
        self.one.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        self.two.setTitleColor(UIColor.tint, for: .normal)
        self.two.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        self.one.addTarget(self, action: #selector(self.initialTouch(sender:)), for: .touchDown)
        self.one.addTarget(self, action: #selector(self.actionOneTouch(sender:)), for: .touchUpInside)
        self.one.addTarget(self, action: #selector(self.endTouch(sender:)), for: .touchUpOutside)
        
        self.two.addTarget(self, action: #selector(self.initialTouch(sender:)), for: .touchDown)
        self.two.addTarget(self, action: #selector(self.actionTwoTouch(sender:)), for: .touchUpInside)
        self.two.addTarget(self, action: #selector(self.endTouch(sender:)), for: .touchUpOutside)
        
        self.addSubview(self.one)
        self.addSubview(self.two)
        
        self.one.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.two.snp.top).offset(-5)
        }
        
        self.two.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: - Actions
    @objc func initialTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            if sender == self.one {
                self.one.backgroundColor = UIColor.selected
            } else {
                self.two.backgroundColor = UIColor.selected
            }
        }
    }
    @objc func endTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            if sender == self.one {
                self.one.backgroundColor = UIColor.clear
            } else {
                self.two.backgroundColor = UIColor.clear
            }
        }
    }
    @objc func actionOneTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.one.backgroundColor = UIColor.clear
        }) { (_) in
            self.complition?(self.one.titleLabel!.text!)
        }
    }
    @objc func actionTwoTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.two.backgroundColor = UIColor.positive
        }) { (_) in
            self.complition?(self.two.titleLabel!.text!)
        }
    }
}
