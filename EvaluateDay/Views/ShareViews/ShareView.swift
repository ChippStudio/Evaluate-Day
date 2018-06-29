//
//  ShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class ShareView: UIView {
    // MARK: - UI
    var logo: UIImageView!
    var title: UILabel!
    var appLink: UILabel!
    var view: UIView!

    // MARK: - Init
    init(view: UIView) {
        super.init(frame: CGRect.zero)
        self.view = view
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init subviews
    fileprivate func initSubviews() {
        // Custom initialization
        let style = Themes.manager.shareViewStyle
        
        // Background
        self.backgroundColor = style.background
        self.layer.borderColor = style.borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10.0
        
        // Logo
        self.logo = UIImageView()
        self.logo.image = #imageLiteral(resourceName: "appIcon").withRenderingMode(.alwaysTemplate)
        self.logo.contentMode = .scaleAspectFit
        self.logo.tintColor = style.titleTint
        
        self.title = UILabel()
        self.title.text = Localizations.general.evaluateday
        self.title.textColor = style.titleTint
        self.title.font = style.titleFont
        
        let titleView = UIView()
        titleView.backgroundColor = UIColor.clear
        
        self.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10.0)
        }
        
        titleView.addSubview(self.logo)
        titleView.addSubview(self.title)
        self.logo.snp.makeConstraints { (make) in
            make.width.equalTo(20.0)
            make.height.equalTo(20.0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        self.title.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.logo)
            make.leading.equalTo(self.logo.snp.trailing).offset(5.0)
            make.trailing.equalToSuperview()
        }
        
        // Main View
        self.addSubview(self.view)
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.view.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0).priority(750.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        // Link
        self.appLink = UILabel()
        self.appLink.text = Localizations.share.description
        self.appLink.textColor = style.descriptionColor
        self.appLink.font = style.descriptionFont
        self.appLink.numberOfLines = 0
        
        self.addSubview(self.appLink)
        self.appLink.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom).offset(5.0).priority(750)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10.0)
        }
    }
}
