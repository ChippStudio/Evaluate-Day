//
//  EvaluateColorShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol EvaluateColorShareViewStyle {
    var evaluateColorShareNoColorDescriptionColor: UIColor { get }
    var evaluateColorShareNoColorDescriptionFont: UIFont { get }
    var evaluateColorShareWhiteBorderColor: UIColor { get }
}

class EvaluateColorShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    var dateLabel = UILabel()
    var colorView: UIView?
    var noColorDescription: UILabel?

    // MARK: - Init
    init(color: String?, title: String, subtitle: String, date: Date) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        self.imageView.image = Sources.image(forType: .color)
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
        
        if let colorValue = color?.color {
            self.colorView = UIView()
            self.colorView?.backgroundColor = colorValue
            if color! == "FFFFFF" {
                self.colorView?.layer.borderColor = style.evaluateColorShareWhiteBorderColor.cgColor
                self.colorView?.layer.borderWidth = 0.5
            }
            self.colorView?.layer.cornerRadius = 5.0
            
            self.addSubview(self.colorView!)
            self.colorView?.snp.makeConstraints({ (make) in
                make.top.equalTo(self.dateLabel.snp.bottom).offset(5.0)
                make.trailing.equalToSuperview().offset(-10.0)
                make.leading.equalToSuperview().offset(10.0)
                make.bottom.equalToSuperview().offset(-10.0)
                make.height.equalTo(50.0)
                make.width.equalTo(280.0)
            })
        } else {
            self.noColorDescription = UILabel()
            self.noColorDescription?.text = Localizations.share.noColor
            self.noColorDescription?.textColor = style.evaluateColorShareNoColorDescriptionColor
            self.noColorDescription?.font = style.evaluateColorShareNoColorDescriptionFont
            self.noColorDescription?.numberOfLines = 0
            self.addSubview(self.noColorDescription!)
            self.noColorDescription?.snp.makeConstraints({ (make) in
                make.top.equalTo(self.dateLabel.snp.bottom).offset(5.0)
                make.trailing.equalToSuperview().offset(-10.0)
                make.leading.equalToSuperview().offset(10.0)
                make.bottom.equalToSuperview().offset(-10.0)
                make.width.equalTo(280.0)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
