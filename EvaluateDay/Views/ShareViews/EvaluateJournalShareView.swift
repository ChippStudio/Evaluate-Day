//
//  EvaluateJournalShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol EvaluateJournalShareViewStyle {
    var shareJournalTextFont: UIFont { get }
    var shareJournalTextColor: UIColor { get }
    var shareJournalMetadataFont: UIFont { get }
    var shareJournalMetadataColor: UIColor { get }
    var shareJournalNoDataFont: UIFont { get }
    var shareJournalNoDataColor: UIColor { get }
}

class EvaluateJournalShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    var dateLabel = UILabel()
    
    // MARK: - Init
    init(entries: [TextValue], title: String, subtitle: String, date: Date) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        self.imageView.image = Sources.image(forType: .journal)
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
        
        if entries.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = Localizations.share.noPhrase
            messageLabel.font = style.shareJournalNoDataFont
            messageLabel.textColor = style.shareJournalNoDataColor
            messageLabel.numberOfLines = 0
            self.addSubview(messageLabel)
            messageLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(dateLabel.snp.bottom).offset(5.0)
                make.trailing.equalToSuperview().offset(-10.0)
                make.leading.equalToSuperview().offset(10.0)
                make.bottom.equalToSuperview().offset(-20.0)
                make.width.equalTo(280.0)
            })
            
        } else {
            var stack = [UIView]()
            for entry in entries {
                let entryView = UIView()
                var photoView: UIImageView!
                
                if let photo = entry.photos.first {
                    photoView = UIImageView()
                    photoView.image = photo.image
                    photoView.layer.masksToBounds = true
                    photoView.layer.cornerRadius = 5.0
                    entryView.addSubview(photoView)
                    photoView.snp.makeConstraints({ (make) in
                        make.height.equalTo(200.0)
                        make.top.equalToSuperview().offset(10.0)
                        make.leading.equalToSuperview().offset(10.0)
                        make.trailing.equalToSuperview().offset(-10.0)
                    })
                }
                
                let textLabel = UILabel()
                textLabel.text = entry.text
                textLabel.font = style.shareJournalTextFont
                textLabel.textColor = style.shareJournalTextColor
                textLabel.numberOfLines = 0
                entryView.addSubview(textLabel)
                textLabel.snp.makeConstraints({ (make) in
                    make.width.equalTo(280.0)
                    make.trailing.equalToSuperview().offset(-10.0)
                    make.leading.equalToSuperview().offset(10.0)
                    if photoView == nil {
                        make.top.equalToSuperview().offset(10.0)
                    } else {
                        make.top.equalTo(photoView.snp.bottom).offset(10.0)
                    }
                })
                
                let metadataLabel = UILabel()
                metadataLabel.textColor = style.shareJournalMetadataColor
                metadataLabel.font = style.shareJournalMetadataFont
                metadataLabel.numberOfLines = 0
                var metadataString = ""
                metadataString += DateFormatter.localizedString(from: entry.created, dateStyle: .none, timeStyle: .short)
                if let loc = entry.location {
                    metadataString += " • "
                    metadataString += loc.streetString
                }
                metadataLabel.text = metadataString
                entryView.addSubview(metadataLabel)
                metadataLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(textLabel.snp.bottom)
                    make.trailing.equalTo(textLabel)
                    make.leading.equalTo(textLabel)
                    make.bottom.equalToSuperview().offset(-10.0)
                })
                
                stack.append(entryView)
            }
            let stackView = UIStackView(arrangedSubviews: stack)
            stackView.axis = .vertical
            stackView.spacing = 20.0
            self.addSubview(stackView)
            stackView.snp.makeConstraints { (make) in
                make.top.equalTo(dateLabel.snp.bottom).offset(5.0)
                make.trailing.equalToSuperview().offset(-10.0)
                make.leading.equalToSuperview().offset(10.0)
                make.bottom.equalToSuperview().offset(-20.0)
                make.width.equalTo(280.0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
