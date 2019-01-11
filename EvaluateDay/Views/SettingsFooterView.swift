//
//  SettingsFooterView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SettingsFooterView: UIView {

    // MARK: - UI
    var appIcon = UIImageView()
    var appTitle = UILabel()
    var appVersion = UILabel()
    
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
        
        self.appIcon.image = #imageLiteral(resourceName: "appIcon").withRenderingMode(.alwaysTemplate)
        self.appIcon.contentMode = .scaleAspectFill
        self.appIcon.tintColor = UIColor.blue
        self.addSubview(self.appIcon)
        self.appIcon.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.width.equalTo(60.0)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20.0)
        }
        
        self.appTitle.textAlignment = .center
        self.appTitle.text = Localizations.General.evaluateday
        self.addSubview(self.appTitle)
        self.appTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.appIcon.snp.bottom).offset(10.0)
            make.centerX.equalToSuperview()
        }
        
        self.appVersion.textAlignment = .center
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        self.appVersion.text = Localizations.General.version(build, version)
        self.addSubview(self.appVersion)
        self.appVersion.snp.makeConstraints { (make) in
            make.top.equalTo(self.appTitle.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }

}
