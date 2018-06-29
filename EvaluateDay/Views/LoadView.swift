//
//  LoadView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 21/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SnapKit

protocol LoadViewStyle {
    var loadCircleColor: UIColor { get }
    var loadBaseViewColor: UIColor { get }
    var loadCoverViewColor: UIColor { get }
    var loadBaseViewAlpha: CGFloat { get }
    var loadCoverViewAlpha: CGFloat { get }
}

class LoadView: UIView {
    
    // MARK: - UI
    var coverView: UIView = UIView() // Big Cover view
    var baseView: UIView = UIView() // Small view
    var bigCircle: UIImageView = UIImageView()
    var middleCircle: UIImageView = UIImageView()
    var smallCircle: UIImageView = UIImageView()
    
    // MARK: - Init
    init(full: Bool, style: LoadViewStyle) {
        super.init(frame: CGRect.zero)
        
        // Set images
        self.bigCircle.image = #imageLiteral(resourceName: "bigCircle").withRenderingMode(.alwaysTemplate)
        self.middleCircle.image = #imageLiteral(resourceName: "middleCircle").withRenderingMode(.alwaysTemplate)
        self.smallCircle.image = #imageLiteral(resourceName: "smallCircle").withRenderingMode(.alwaysTemplate)
        
        self.bigCircle.tintColor = style.loadCircleColor
        self.middleCircle.tintColor = style.loadCircleColor
        self.smallCircle.tintColor = style.loadCircleColor
        
        // Set cover
        self.coverView.backgroundColor = style.loadCoverViewColor
        self.coverView.alpha = style.loadCoverViewAlpha
        
        // Set base
        self.baseView.backgroundColor = style.loadBaseViewColor
        self.baseView.alpha = style.loadBaseViewAlpha
        self.baseView.layer.cornerRadius = 10.0
        
        // Set all constraint
        self.addSubview(self.coverView)
        self.coverView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.addSubview(self.baseView)
        self.baseView.snp.makeConstraints { (make) in
            make.width.equalTo(100.0)
            make.height.equalTo(100.0)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.top).offset(300.0)
        }
        
        let circleSize: CGFloat = 70.0
        self.addSubview(self.bigCircle)
        self.bigCircle.snp.makeConstraints { (make) in
            make.width.equalTo(circleSize)
            make.height.equalTo(circleSize)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.top).offset(300.0)
        }
        
        self.addSubview(self.middleCircle)
        self.middleCircle.snp.makeConstraints { (make) in
            make.width.equalTo(circleSize)
            make.height.equalTo(circleSize)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.top).offset(300.0)
        }
        
        self.addSubview(self.smallCircle)
        self.smallCircle.snp.makeConstraints { (make) in
            make.width.equalTo(circleSize)
            make.height.equalTo(circleSize)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.top).offset(300.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    func startAnimation() {
        self.stopFlag = false
        self.bigCircleAnimation()
        self.middleCircleAnimation()
        self.smallCircleAnimation()
    }
    
    func stopAnimation() {
        self.stopFlag = true
    }
    
    // MARK: - Private Actions
    private var stopFlag: Bool = false
    
    private var bigFlag = 0
    private func bigCircleAnimation() {
        UIView.animate(withDuration: 1.2, delay: 0.0, options: .curveEaseInOut, animations: {
            if self.bigFlag == 0 {
                self.bigCircle.alpha = 0.0
                self.bigFlag = 1
            } else {
                self.bigCircle.alpha = 1.0
                self.bigFlag = 0
            }
        }) { (_) in
            if !self.stopFlag {
                self.bigCircleAnimation()
            }
        }
    }
    
    private var middleFlag = 0
    private func middleCircleAnimation() {
        UIView.animate(withDuration: 1.6, delay: 0.0, options: .curveEaseInOut, animations: {
            if self.middleFlag == 0 {
                self.middleCircle.alpha = 0.0
                self.middleFlag = 1
            } else {
                self.middleCircle.alpha = 1.0
                self.middleFlag = 0
            }
        }) { (_) in
            if !self.stopFlag {
                self.self.middleCircleAnimation()
            }
        }
    }
    private var smallFlag = 0
    private func smallCircleAnimation() {
        UIView.animate(withDuration: 1.9, delay: 0.0, options: .curveEaseInOut, animations: {
            if self.smallFlag == 0 {
                self.smallCircle.alpha = 0.0
                self.smallFlag = 1
            } else {
                self.smallCircle.alpha = 1.0
                self.smallFlag = 0
            }
        }) { (_) in
            if !self.stopFlag {
                self.smallCircleAnimation()
            }
        }
    }
}
