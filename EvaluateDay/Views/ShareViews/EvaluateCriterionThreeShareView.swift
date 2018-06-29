//
//  EvaluateCriterionThreeShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol EvaluateCriterionThreeShareViewStyle {
    var evaluateThreeCriterionMessageColor: UIColor { get }
    var evaluateThreeCriterionMessageFont: UIFont { get }
    var evaluateThreeCriterionNegativeColor: UIColor { get }
    var evaluateThreeCriterionPositiveColor: UIColor { get }
    var evaluateThreeCriterionNeutralColor: UIColor { get }
    var evaluateThreeCriterionUnsetColor: UIColor { get }
}

class EvaluateCriterionThreeShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    var dateLabel = UILabel()
    var messageLabel = UILabel()
    var goodImageView = UIImageView()
    var neutralImageView = UIImageView()
    var badImageView = UIImageView()
    
    // MARK: - Init
    init(value: Double?, positive: Bool, title: String, subtitle: String, date: Date) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        self.imageView.image = Sources.image(forType: .criterionThree)
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
        if value == nil {
            self.messageLabel.text = Localizations.share.noThreeValue
        }
        self.messageLabel.textColor = style.evaluateThreeCriterionMessageColor
        self.messageLabel.font = style.evaluateThreeCriterionMessageFont
        self.messageLabel.numberOfLines = 0
        self.addSubview(self.messageLabel)
        self.messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.width.equalTo(280.0)
        }
        
        self.neutralImageView.image = #imageLiteral(resourceName: "neutral").withRenderingMode(.alwaysTemplate)
        self.neutralImageView.contentMode = .scaleAspectFit
        self.neutralImageView.tintColor = style.evaluateThreeCriterionUnsetColor
        if value != nil {
            if value == 1 {
                self.neutralImageView.tintColor = style.evaluateThreeCriterionNeutralColor
            }
        }
        self.addSubview(self.neutralImageView)
        self.neutralImageView.snp.makeConstraints { (make) in
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.messageLabel.snp.bottom).offset(10.0)
            make.bottom.equalToSuperview().offset(-10.0)
        }
        
        self.goodImageView.image = #imageLiteral(resourceName: "good").withRenderingMode(.alwaysTemplate)
        self.goodImageView.contentMode = .scaleAspectFit
        self.goodImageView.tintColor = style.evaluateThreeCriterionUnsetColor
        if value != nil {
            if value == 2 {
                if positive {
                    self.goodImageView.tintColor = style.evaluateThreeCriterionPositiveColor
                } else {
                    self.goodImageView.tintColor = style.evaluateThreeCriterionNegativeColor
                }
            }
        }
        self.addSubview(self.goodImageView)
        self.goodImageView.snp.makeConstraints { (make) in
            make.height.equalTo(50.0)
            make.width.equalTo(50.0)
            make.top.equalTo(self.neutralImageView)
            make.trailing.equalTo(self.neutralImageView.snp.leading).offset(-10.0)
        }
        
        self.badImageView.image = #imageLiteral(resourceName: "bad").withRenderingMode(.alwaysTemplate)
        self.badImageView.contentMode = .scaleAspectFit
        self.badImageView.tintColor = style.evaluateThreeCriterionUnsetColor
        if value != nil {
            if value == 0 {
                if positive {
                    self.badImageView.tintColor = style.evaluateThreeCriterionNegativeColor
                } else {
                    self.badImageView.tintColor = style.evaluateThreeCriterionPositiveColor
                }
            }
        }
        self.addSubview(self.badImageView)
        self.badImageView.snp.makeConstraints { (make) in
            make.height.equalTo(50.0)
            make.width.equalTo(50.0)
            make.top.equalTo(self.neutralImageView)
            make.leading.equalTo(self.neutralImageView.snp.trailing).offset(10.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
