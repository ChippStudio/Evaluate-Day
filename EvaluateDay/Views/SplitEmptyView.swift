//
//  SplitEmptyView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/07/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SnapKit

class SplitEmptyView: UIView {
    
    // MARK: - UI
    var image = UIImageView()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    // MARK: - Init subviews
    fileprivate func initSubviews() {
        // Custom initialization
        self.image.image = UIImage(named: "dashboard-\(34.random)")
        self.image.contentMode = .scaleAspectFill
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 250/2
        self.image.alpha = 0.7
        
        self.addSubview(self.image)
        self.image.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(250.0)
            make.width.equalTo(250.0)
        }
    }
}
