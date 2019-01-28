//
//  CardListEmptyView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    // MARK: - UI
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var button = UIButton()
    var buttonCover = UIView()
    
    // MARK: - Override
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.tintColor = UIColor.main
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(60.0)
            make.width.equalTo(60.0)
            make.top.equalToSuperview().offset(40.0)
        }
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textColor = UIColor.main
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-20.0)
            make.leading.equalTo(self).offset(20.0)
            make.top.equalTo(self.imageView.snp.bottom).offset(20.0)
        }
        
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textColor = UIColor.main
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-20.0)
            make.leading.equalTo(self).offset(20.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20.0)
        }
        
        self.button.setTitleColor(UIColor.textTint, for: .normal)
        self.buttonCover.layer.masksToBounds = true
        self.buttonCover.layer.cornerRadius = 10.0
        self.buttonCover.backgroundColor = UIColor.main
        self.buttonCover.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(50.0)
            make.width.equalTo(230.0)
        }
        
        self.addSubview(self.buttonCover)
        self.buttonCover.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(20.0)
        }
        
        self.button.addTarget(self, action: #selector(self.startTouch(sender:)), for: .touchDown)
        self.button.addTarget(self, action: #selector(self.cancelTouch(sender:)), for: .touchUpOutside)
        self.button.addTarget(self, action: #selector(self.cancelTouch(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Action
    @objc func startTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.buttonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func cancelTouch(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.buttonCover.backgroundColor = UIColor.main
        }
    }
}
