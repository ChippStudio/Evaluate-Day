//
//  ShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SnapKit

class ShareView: UIView {
    // MARK: - UI
    var title: UILabel!
    var iconImage: UIImageView!
    var link: UILabel!
    var sharedImage: UIImageView!
    
    // MARK: - Variable
    var image: UIImage!
    
    // MARK: - Init
    init(image: UIImage) {
        super.init(frame: CGRect.zero)
        self.image = image
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    // MARK: - Init subviews
    fileprivate func initSubviews() {
        // Custom initialization
        let style = Themes.manager.shareViewStyle
        
        self.title = UILabel()
        self.title.text = Localizations.general.evaluateday.uppercased()
        self.title.font = style.shareViewTitleFont
        self.title.textColor = style.shareViewTitleColor
        self.title.textAlignment = .center
        
        self.iconImage = UIImageView()
        self.iconImage.contentMode = .scaleAspectFill
        self.iconImage.layer.masksToBounds = true
        self.iconImage.layer.cornerRadius = 3.0
        self.iconImage.image = style.shareViewIconImage
        
        self.link = UILabel()
        self.link.text = appSiteURLString
        self.link.font = style.shareViewLinkFont
        self.link.textColor = style.shareViewLinkColor
        self.link.textAlignment = .right
        
        self.sharedImage = UIImageView()
        self.sharedImage.contentMode = .scaleAspectFill
        self.sharedImage.layer.masksToBounds = true
        self.sharedImage.layer.cornerRadius = 3.0
        self.sharedImage.image = self.image
        
        self.backgroundColor = style.shareViewBackgroundColor
        
        self.addSubview(self.title)
        self.addSubview(self.sharedImage)
        self.addSubview(self.iconImage)
        self.addSubview(self.link)
        
        self.title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().offset(-20.0)
        }
        
        self.sharedImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().offset(-20.0)
            make.width.equalTo(self.image.size.width)
            make.height.equalTo(self.image.size.height)
        }
        
        self.iconImage.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.width.equalTo(20.0)
            make.top.equalTo(self.sharedImage.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().offset(10.0)
            make.bottom.equalToSuperview().offset(-10.0)
        }
        
        self.link.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.iconImage)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalTo(self.iconImage.snp.trailing).offset(10.0)
        }
    }
}
