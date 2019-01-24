//
//  ActionProView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class ActionProView: UIView, ActionView {
    
    // MARK: - UI
    var proView = ProView()
    var nextButton = UIButton()
    
    // MARK: - Variables
    var complition: ((String) -> Void)?
    var proUser: User!
    var proToken: NotificationToken!
    
    // MARK: - Init
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
        
        self.proUser = Database.manager.app.objects(User.self).first
        if self.proUser != nil {
            self.proToken =  self.proUser.observe { (change) in
                if self.proUser.pro {
                    self.nextButton.setTitle(Localizations.Welcome.New.Pro.buyed, for: .normal)
                } else {
                    self.nextButton.setTitle(Localizations.Welcome.New.Pro.notBuyed, for: .normal)
                }
            }
        }
        
        self.backgroundColor = UIColor.positive
        
        self.nextButton.layer.cornerRadius = 10.0
        self.nextButton.setTitleColor(UIColor.tint, for: .normal)
        self.nextButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        self.nextButton.addTarget(self, action: #selector(self.initialTouch(sender:)), for: .touchDown)
        self.nextButton.addTarget(self, action: #selector(self.actionTouch(sender:)), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.endTouch(sender:)), for: .touchUpOutside)
        
        self.addSubview(self.proView)
        self.addSubview(self.nextButton)
        
        self.proView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.height.equalTo(140.0)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.proView.snp.bottom).offset(20.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.height.equalTo(60.0)
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
            self.nextButton.backgroundColor = UIColor.tint
        }
    }
    @objc func endTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.nextButton.backgroundColor = UIColor.clear
        }
    }
    @objc func actionTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.backgroundColor = UIColor.clear
        }) { (_) in
            self.complition?(self.nextButton.titleLabel!.text!)
        }
    }
}
