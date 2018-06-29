//
//  NextButton.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 22/09/2016.
//  Copyright © 2016 Chipp Studio. All rights reserved.
//

import UIKit
import SnapKit

class NextButton: UIControl {
    //Mark - UI
    var contentView = UIView()
    var imageView = UIImageView()
    
    //Mark - Init
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
        }
        self.contentView.isUserInteractionEnabled = false
        
        self.contentView.addSubview(imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(30.0)
            make.width.equalTo(30.0)
        }
        self.imageView.isUserInteractionEnabled = false
        
        self.contentView.layer.cornerRadius = 30.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.gunmetal.cgColor
        
        self.imageView.image  = #imageLiteral(resourceName: "up").withRenderingMode(.alwaysTemplate)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.tintColor = UIColor.gunmetal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    //Mark - Override
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.2) {
            self.contentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.contentView.transform = CGAffineTransform.identity
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
    }
}
