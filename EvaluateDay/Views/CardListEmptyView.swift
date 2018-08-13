//
//  CardListEmptyView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol CardListEmptyViewStyle {
    var cardListEmptyTitleFont: UIFont { get }
    var cardListEmptyTitleColor: UIColor { get }
    var cardListEmptyDescriptionFont: UIFont { get }
    var cardListEmptyDescriptionColor: UIColor { get }
    var cardListEmptyNewFont: UIFont { get }
    var cardListEmptyNewTintColor: UIColor { get }
    var cardListEmptyNewTintHighlightedColor: UIColor { get }
    var cardListEmptyNewBackgroundColor: UIColor { get }
}

class CardListEmptyView: UIView {
    // MARK: - UI
    var titleLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    
    var newCover = UIView()
    var newImage = UIImageView()
    var newLabel = UILabel()
    var newButton = UIButton()
    
    // MARK: - Variables
    var style: CardListEmptyViewStyle! {
        didSet {
            self.implementStyle()
        }
    }
    
    // MARK: - Override
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
        
        self.titleLabel.numberOfLines = 0
        self.descriptionLabel.numberOfLines = 0
        
        self.titleLabel.text = Localizations.list.card.empty.title
        self.descriptionLabel.text = Localizations.list.card.empty.description
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
        
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30.0)
            make.trailing.equalToSuperview().offset(-30.0).priority(750.0)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80.0)
            make.bottom.equalTo(self.descriptionLabel.snp.top).offset(-10.0)
            make.leading.equalToSuperview().offset(30.0)
            make.trailing.equalToSuperview().offset(-30.0).priority(750.0)
        }
        
        self.newCover.layer.cornerRadius = 23.0
        
        self.newImage.image = #imageLiteral(resourceName: "new").withRenderingMode(.alwaysTemplate)
        self.newImage.contentMode = .scaleAspectFit
        
        self.newLabel.text = Localizations.new.cards.action
        
        self.addSubview(newCover)
        self.newCover.addSubview(self.newImage)
        self.newCover.addSubview(self.newLabel)
        
        self.newImage.snp.makeConstraints { (make) in
            make.height.equalTo(25.0)
            make.width.equalTo(25.0)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20.0)
        }
        self.newLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.newImage.snp.trailing).offset(10.0)
            make.trailing.equalToSuperview().offset(-20.0)
        }
        
        self.newCover.snp.makeConstraints { (make) in
            make.height.equalTo(46.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(40.0)
        }
        
        self.addSubview(self.newButton)
        self.newButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.newCover)
            make.bottom.equalTo(self.newCover)
            make.trailing.equalTo(self.newCover)
            make.leading.equalTo(self.newCover)
        }
        
        self.newButton.addTarget(self, action: #selector(self.startTouch(sender:)), for: .touchDown)
        self.newButton.addTarget(self, action: #selector(self.cancelTouch(sender:)), for: .touchUpOutside)
        self.newButton.addTarget(self, action: #selector(self.endTouch(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Action
    @objc func startTouch(sender: UIButton) {
        self.animateShare(toColor: self.style.cardListEmptyNewTintHighlightedColor)
    }
    
    @objc func cancelTouch(sender: UIButton) {
        self.animateShare(toColor: self.style.cardListEmptyNewTintColor)
    }
    
    @objc func endTouch(sender: UIButton) {
        self.animateShare(toColor: self.style.cardListEmptyNewTintColor)
    }
    
    // MARK: - Private
    private func animateShare( toColor color: UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.newImage.tintColor = color
            self.newLabel.textColor = color
        }
    }
    
    // MARK: - Private
    private func implementStyle() {
        self.titleLabel.textColor = self.style.cardListEmptyTitleColor
        self.titleLabel.font = self.style.cardListEmptyTitleFont
        
        self.descriptionLabel.textColor = self.style.cardListEmptyDescriptionColor
        self.descriptionLabel.font = self.style.cardListEmptyDescriptionFont
        
        self.newImage.tintColor = self.style.cardListEmptyNewTintColor
        self.newLabel.font = self.style.cardListEmptyNewFont
        self.newLabel.textColor = self.style.cardListEmptyNewTintColor
        self.newCover.backgroundColor = self.style.cardListEmptyNewBackgroundColor
    }
}
