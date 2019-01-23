//
//  ActionButtonView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class ActionButtonView: UIView, ActionView {
    
    // MARK: - UI
    var button = UIButton()
    
    // MARK: - Variables
    var complition: ((String) -> Void)?
    
    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        self.button.setTitleColor(UIColor.tint, for: .normal)
        self.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        self.button.addTarget(self, action: #selector(self.initialTouch(sender:)), for: .touchDown)
        self.button.addTarget(self, action: #selector(self.actionTouch(sender:)), for: .touchUpInside)
        self.button.addTarget(self, action: #selector(self.endTouch(sender:)), for: .touchUpOutside)
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.top.equalToSuperview()
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
            self.backgroundColor = UIColor.selected
        }
    }
    @objc func endTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.positive
        }
    }
    @objc func actionTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.positive
        }) { (_) in
            self.complition?(self.button.titleLabel!.text!)
        }
    }
}
