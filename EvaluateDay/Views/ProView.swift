//
//  ProView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class ProView: UIView {
    
    // MARK: - UI
    var unlockLabel = UILabel()
    var evaluateDayLabel = UILabel()
    var readMoreLabel = UILabel()
    var miniProLabel = UIView()
    
    var button = UIButton()

    // MARK: - Override
    init() {
        super.init(frame: CGRect.zero)
        self.initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    // MARK: - Actions
    @objc func viewInitialAction(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.selected
        }
    }
    
    @objc func viewEndAction(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.main
        }
    }
    
    // MARK: - Init subviews
    fileprivate func initSubviews() {
        // Custom initialization
        
        self.backgroundColor = UIColor.main
        self.layer.cornerRadius = 10.0
        
        // Generate Pro View
        self.miniProLabel.backgroundColor = UIColor.textTint
        self.miniProLabel.layer.cornerRadius = 10.0

        let proLabel = UILabel()
        proLabel.text = "PRO"
        proLabel.textColor = UIColor.selected
        proLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        proLabel.isAccessibilityElement = false

        let icon = UIImageView()
        icon.image = Images.Media.appIcon.image.resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor.main

        self.miniProLabel.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.height.equalTo(30.0)
            make.width.equalTo(30.0)
            make.top.equalTo(self.miniProLabel).offset(4.0)
            make.bottom.equalTo(self.miniProLabel).offset(-4.0)
            make.leading.equalTo(self.miniProLabel).offset(7.0)
        }

        self.miniProLabel.addSubview(proLabel)
        proLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(icon.snp.trailing).offset(5.0)
            make.trailing.equalTo(self.miniProLabel).offset(-9.0)
            make.centerY.equalTo(icon)
        }

        // All labels
        self.evaluateDayLabel.text = Localizations.General.evaluateday
        self.evaluateDayLabel.textColor = UIColor.textTint
        self.evaluateDayLabel.font = UIFont.systemFont(ofSize: 27.0, weight: .bold)

        self.readMoreLabel.text = Localizations.Settings.Pro.View.readMore
        self.readMoreLabel.textColor = UIColor.textTint
        self.readMoreLabel.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        self.readMoreLabel.adjustsFontSizeToFitWidth = true

        // Main view
        self.addSubview(self.evaluateDayLabel)
        self.addSubview(self.miniProLabel)

        self.evaluateDayLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(25.0)
        }
        self.miniProLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-20.0)
            make.leading.greaterThanOrEqualTo(self.evaluateDayLabel.snp.trailing).offset(10.0)
            make.centerY.equalToSuperview()
        }

        if !Store.current.isPro {
            self.unlockLabel.text = Localizations.Settings.Pro.View.unlock
            self.unlockLabel.textColor = UIColor.textTint
            self.unlockLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            self.addSubview(self.unlockLabel)
            self.unlockLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(self).offset(25.0)
                make.bottom.equalTo(self.evaluateDayLabel.snp.top).offset(-10.0)
            }
        }

        self.addSubview(self.readMoreLabel)
        self.readMoreLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10.0)
            make.bottom.equalToSuperview().offset(-10.0)
        }
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.button.addTarget(self, action: #selector(self.viewInitialAction(sender:)), for: .touchDown)
        self.button.addTarget(self, action: #selector(self.viewEndAction(sender:)), for: .touchUpOutside)
        self.button.addTarget(self, action: #selector(self.viewEndAction(sender:)), for: .touchUpInside)
        self.button.addTarget(self, action: #selector(self.viewEndAction(sender:)), for: .touchCancel)
        
        // Set accesebility
        self.unlockLabel.isAccessibilityElement = false
        self.evaluateDayLabel.isAccessibilityElement = false
        self.readMoreLabel.isAccessibilityElement = false
        
        self.button.accessibilityLabel = Localizations.Accessibility.Pro.open
    }
}
