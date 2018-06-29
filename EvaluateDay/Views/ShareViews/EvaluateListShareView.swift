//
//  EvaluateListShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol EvaluateListShareViewStyle {
    var listEvaluateShareDayDoneFont: UIFont { get }
    var listEvaluateShareDayDoneColor: UIColor { get }
    var listEvaluateShareAllDoneFont: UIFont { get }
    var listEvaluateShareAllDoneColor: UIColor { get }
}

class EvaluateListShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    var dateLabel = UILabel()
    var dayLabel = UILabel()
    var allLabel = UILabel()
    
    // MARK: - Init
    init(all: Int, inDayDone: Int, allDone: Int, title: String, subtitle: String, date: Date) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        self.imageView.image = Sources.image(forType: .habit)
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
        
        let allPercent = Double(allDone) / Double(all) * 100.0
        let dayPercent = Double(inDayDone) / Double(all) * 100.0
        
        let dayString = "\(inDayDone) / \(all) \n \(String(format: "%.0f", dayPercent)) %"
        let allString = "\(allDone) / \(all) \n \(String(format: "%.0f", allPercent)) %"
        
        self.dayLabel.text = dayString
        self.dayLabel.numberOfLines = 2
        self.dayLabel.font = style.listEvaluateShareDayDoneFont
        self.dayLabel.textColor = style.listEvaluateShareDayDoneColor
        self.dayLabel.textAlignment = .center
        self.addSubview(self.dayLabel)
        self.dayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.bottom.equalToSuperview().offset(-10.0)
            make.width.equalTo(130.0)
        }
        
        self.allLabel.text = allString
        self.allLabel.numberOfLines = 2
        self.allLabel.font = style.listEvaluateShareAllDoneFont
        self.allLabel.textColor = style.listEvaluateShareAllDoneColor
        self.allLabel.textAlignment = .center
        self.addSubview(self.allLabel)
        self.allLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalTo(self.dayLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-10.0)
            make.width.equalTo(130.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
