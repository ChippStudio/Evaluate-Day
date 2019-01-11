//
//  PresentFutureEmptyView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol PresentFutureEmptyViewStyle {
    var presentFutureQuoteFont: UIFont { get }
    var presentFutureQuoteColor: UIColor { get }
    var presentFutureAuthorFont: UIFont { get }
    var presentFutureAuthorColor: UIColor { get }
    var presentFutureShareFont: UIFont { get }
    var presentFutureShareTintColor: UIColor { get }
    var presentFutureShareTintHighlightedColor: UIColor { get }
    var presentFutureShareBackgroundColor: UIColor { get }
}

class PresentFutureEmptyView: UIView {
    
    // MARK: - UI
    var quote = UILabel()
    var author = UILabel()
    var shareCover = UIView()
    var shareImage = UIImageView()
    var shareLabel = UILabel()
    var shareButton = UIButton()
    
    // MARK: - Variables
    var style: PresentFutureEmptyViewStyle! {
        didSet {
            self.implementStyle()
        }
    }
    
    // MARK: - Init
    init(message: String, author: String) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
        
        self.quote.text = message
        self.quote.numberOfLines = 0
        self.quote.textAlignment = .left
        self.addSubview(self.quote)
        self.quote.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80.0)
            make.trailing.equalToSuperview().offset(-10.0).priority(751.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        self.author.text = author
        self.author.numberOfLines = 1
        self.author.textAlignment = .right
        self.addSubview(self.author)
        self.author.snp.makeConstraints { (make) in
            make.top.equalTo(self.quote.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0).priority(750.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        self.shareCover.layer.cornerRadius = 23.0
        
        self.shareImage.image = #imageLiteral(resourceName: "share").withRenderingMode(.alwaysTemplate)
        self.shareImage.contentMode = .scaleAspectFit
        
        self.shareLabel.text = Localizations.Calendar.Empty.share
        
        self.addSubview(shareCover)
        self.shareCover.addSubview(self.shareImage)
        self.shareCover.addSubview(self.shareLabel)
        
        self.shareImage.snp.makeConstraints { (make) in
            make.height.equalTo(25.0)
            make.width.equalTo(25.0)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20.0)
        }
        self.shareLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.shareImage.snp.trailing).offset(10.0)
            make.trailing.equalToSuperview().offset(-20.0)
        }
        
        self.shareCover.snp.makeConstraints { (make) in
            make.height.equalTo(46.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.author.snp.bottom).offset(40.0)
        }
        
        self.addSubview(self.shareButton)
        self.shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.shareCover)
            make.bottom.equalTo(self.shareCover)
            make.trailing.equalTo(self.shareCover)
            make.leading.equalTo(self.shareCover)
        }
        
        self.shareButton.addTarget(self, action: #selector(self.startTouch(sender:)), for: .touchDown)
        self.shareButton.addTarget(self, action: #selector(self.cancelTouch(sender:)), for: .touchUpOutside)
        self.shareButton.addTarget(self, action: #selector(self.endTouch(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Action
    @objc func startTouch(sender: UIButton) {
        self.animateShare(toColor: self.style.presentFutureShareTintHighlightedColor)
    }
    
    @objc func cancelTouch(sender: UIButton) {
        self.animateShare(toColor: self.style.presentFutureShareTintColor)
    }
    
    @objc func endTouch(sender: UIButton) {
        self.animateShare(toColor: self.style.presentFutureShareTintColor)
    }
    
    // MARK: - Private
    private func animateShare( toColor color: UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.shareImage.tintColor = color
            self.shareLabel.textColor = color
        }
    }
    private func implementStyle() {
        self.quote.textColor = self.style.presentFutureQuoteColor
        self.quote.font = self.style.presentFutureQuoteFont
        
        self.author.textColor = self.style.presentFutureAuthorColor
        self.author.font = self.style.presentFutureAuthorFont
        
        self.shareImage.tintColor = self.style.presentFutureShareTintColor
        self.shareLabel.font = self.style.presentFutureShareFont
        self.shareLabel.textColor = self.style.presentFutureShareTintColor
        self.shareCover.backgroundColor = self.style.presentFutureShareBackgroundColor
    }
}
