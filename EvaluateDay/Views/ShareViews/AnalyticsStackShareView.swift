//
//  AnalyticsStackShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol AnalyticsStackShareViewStyle {
    var stackTextColor: UIColor { get }
    var stackTextFont: UIFont { get }
}

class AnalyticsStackShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    
    init(stack: [UIView], text: String, title: String, subtitle: String, type: CardType) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        self.imageView.image = Sources.image(forType: type)
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.width.equalTo(30.0)
            make.height.equalTo(30.0)
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        self.title.text = title
        self.title.textColor = style.cardShareTitleColor
        self.title.font = style.cardShareTitleFont
        self.title.numberOfLines = 0
        self.addSubview(self.title)
        self.title.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageView.snp.trailing).offset(5.0)
            make.top.equalToSuperview().offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
        }
        
        self.subtitle.text = subtitle
        self.subtitle.textColor = style.cardShareSubtitleColor
        self.subtitle.font = style.cardShareSubtitleFont
        self.subtitle.numberOfLines = 0
        self.addSubview(self.subtitle)
        self.subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom)
            make.leading.equalTo(self.imageView.snp.trailing).offset(5.0)
            make.trailing.equalToSuperview().offset(-10.0)
        }
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = text
        descriptionLabel.textColor = style.stackTextColor
        descriptionLabel.font = style.stackTextFont
        descriptionLabel.numberOfLines = 0
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.subtitle.snp.bottom).offset(20.0)
            make.top.greaterThanOrEqualTo(self.imageView.snp.bottom).offset(20.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        let stackView = UIStackView(arrangedSubviews: stack)
        stackView.axis = .vertical
        stackView.spacing = 5.0
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.bottom.equalToSuperview().offset(-20.0)
            make.width.equalTo(280.0)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
