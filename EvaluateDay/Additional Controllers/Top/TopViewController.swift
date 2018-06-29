//
//  TopViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SnapKit

/// Class container
class TopViewController: UIViewController {

    // MARK: - UI
    var maskView = UIView()
    var contentView = UIView()
    
    // MARK: - Variables
    var closeByTap: Bool = false
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .overFullScreen
        self.transition = TopTransition(animationDuration: 0.4)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let style = Themes.manager.topViewControllerStyle
        
        // Set mask and content view
        self.maskView.backgroundColor = style.maskColor
        self.maskView.alpha = style.maskAlpha
        self.view.addSubview(self.maskView)
        
        self.maskView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.contentView.backgroundColor = style.topViewColor
        self.setConstraints(inTraitCollection: UIApplication.shared.keyWindow!.rootViewController!.view.traitCollection)
        
        // Set gesture recognizer
        self.maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maskViewTapAction(sender:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.setConstraints(inTraitCollection: newCollection)
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    // MARK: - Actions
    @objc private func maskViewTapAction(sender: UITapGestureRecognizer) {
        if self.closeByTap {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private
    private func setConstraints(inTraitCollection collection: UITraitCollection) {
        self.contentView.removeFromSuperview()
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            if collection.horizontalSizeClass == .compact {
                make.top.equalToSuperview()
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            } else {
                make.top.equalToSuperview().offset(40.0)
                make.centerX.equalToSuperview()
                make.width.equalTo(500.0)
            }
        }
        
        if collection.horizontalSizeClass == .compact {
            self.contentView.layer.cornerRadius = 0.0
        } else {
            self.contentView.layer.cornerRadius = 10.0
            self.contentView.clipsToBounds = true
        }
    }
}
