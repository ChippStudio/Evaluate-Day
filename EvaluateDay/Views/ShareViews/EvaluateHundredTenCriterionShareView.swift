//
//  EvaluateHundredTenCriterionShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol EvaluateHundredTenCriterionShareViewStyle {
    var evaluateHundredTenCriterionNegativeColor: UIColor { get }
    var evaluateHundredTenCriterionPositiveColor: UIColor { get }
    var evaluateHundredTenCriterionColor: UIColor { get }
    var evaluateHundredTenCriterionValueColor: UIColor { get }
    var evaluateHundredTenCriterionValueFont: UIFont { get }
}

class EvaluateHundredTenCriterionShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    var dateLabel = UILabel()
    var valueLabel = UILabel()
    var slider = UISlider()
    
    // MARK: - Init
    init(value: Double?, scale: Int, positive: Bool, title: String, subtitle: String, date: Date) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        if scale == 100 {
            self.imageView.image = Sources.image(forType: .criterionHundred)
        } else if scale == 10 {
            self.imageView.image = Sources.image(forType: .criterionTen)
        }
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
        
        // Set slider and value
        self.valueLabel.textColor = style.evaluateHundredTenCriterionValueColor
        self.valueLabel.font = style.evaluateHundredTenCriterionValueFont
        self.valueLabel.numberOfLines = 0
        if value != nil {
            self.valueLabel.text = "\(String(format: "%0.f", value!))/\(scale)"
        } else {
            if scale == 100 {
                self.valueLabel.text = Localizations.share.noHundredValue
            } else if scale == 10 {
                self.valueLabel.text = Localizations.share.noTenValue
            }
        }
        self.addSubview(self.valueLabel)
        self.valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(20.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        self.slider.maximumValue = Float(scale)
        self.slider.setValue(0.0, animated: false)
        if value != nil {
            self.slider.setValue(Float(value!), animated: false)
        }
        self.slider.maximumTrackTintColor = style.evaluateHundredTenCriterionColor
        if positive {
            self.slider.minimumTrackTintColor = style.evaluateHundredTenCriterionPositiveColor
        } else {
            self.slider.minimumTrackTintColor = style.evaluateHundredTenCriterionNegativeColor
        }
        
        self.addSubview(self.slider)
        self.slider.snp.makeConstraints { (make) in
            make.top.equalTo(self.valueLabel.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.bottom.equalToSuperview().offset(-10.0)
            make.width.equalTo(280.0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
