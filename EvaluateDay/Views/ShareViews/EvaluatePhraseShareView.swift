//
//  EvaluatePhraseShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol EvaluatePhraseShareViewStyle {
    var evaluatePhraseTextColor: UIColor { get }
    var evaluatePhraseTextFont: UIFont { get }
}

class EvaluatePhraseShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    var dateLabel = UILabel()
    var textLabel = UILabel()
    
    // MARK: - Init
    init(text: String, title: String, subtitle: String, date: Date) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        self.imageView.image = Sources.image(forType: .criterionHundred)
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
        
        self.dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        self.dateLabel.textColor = style.cardShareDateColor
        self.dateLabel.font = style.cardShareDateFont
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.subtitle.snp.bottom).offset(5.0)
            make.top.greaterThanOrEqualTo(self.imageView.snp.bottom).offset(5.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        // Message
        if text == "" {
            self.textLabel.text = Localizations.share.noPhrase
        } else {
            self.textLabel.text = text
        }
        self.textLabel.textColor = style.evaluatePhraseTextColor
        self.textLabel.font = style.evaluatePhraseTextFont
        self.textLabel.numberOfLines = 0
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.width.equalTo(280.0)
            make.bottom.equalToSuperview().offset(-20.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
