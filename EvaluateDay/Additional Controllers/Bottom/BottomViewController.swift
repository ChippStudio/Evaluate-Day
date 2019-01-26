//
//  BottomViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

/// Class container
class BottomViewController: UIViewController {
    // MARK: - UI
    var maskView = UIView()
    var contentView = UIView()
    var closeButton: UIButton!
    
    // MARK: - Variables
    var closeByTap: Bool = false
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .overFullScreen
        self.transition = BottomTransition(animationDuration: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set mask and content view
        self.maskView.backgroundColor = UIColor.black
        self.maskView.alpha = 0.5
        self.view.addSubview(self.maskView)
        
        self.maskView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.closeButton = UIButton()
//        self.closeButton.tintColor = UIColor.main
//        self.closeButton.setImage(Images.Media.close.image.resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonAction(sender:)), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        self.closeButton.accessibilityLabel = Localizations.General.close
        
        self.closeButton.snp.makeConstraints { (make) in
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
            make.leading.equalTo(self.view).offset(10.0)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10.0)
            } else {
                make.top.equalTo(self.view).offset(30.0)
            }
        }
        
        self.contentView.backgroundColor = UIColor.background
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
    
    @objc func closeButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func setConstraints(inTraitCollection collection: UITraitCollection) {
        self.contentView.removeFromSuperview()
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            if collection.horizontalSizeClass == .compact {
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            } else {
                make.bottom.equalToSuperview().offset(-60.0)
                make.centerX.equalToSuperview()
                make.width.equalTo(500.0)
            }
        }
        
        if collection.horizontalSizeClass == .compact {
            self.contentView.layer.cornerRadius = 5.0
            self.contentView.clipsToBounds = true
        } else {
            self.contentView.layer.cornerRadius = 10.0
            self.contentView.clipsToBounds = true
        }
    }
}
