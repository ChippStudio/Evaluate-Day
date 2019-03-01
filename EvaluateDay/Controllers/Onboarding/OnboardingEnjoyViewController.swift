//
//  OnbordingEnjoyViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/03/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class OnboardingEnjoyViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = 10.0
        
        self.textLabel.textColor = UIColor.text
        self.textLabel.text = Localizations.Onboarding.Enjoy.text
        
        self.startButton.layer.cornerRadius = 10.0
        self.startButton.backgroundColor = UIColor.main
        self.startButton.setTitleColor(UIColor.textTint, for: .normal)
        self.startButton.setTitle(Localizations.Onboarding.Enjoy.button, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func startButtonAction(_ sender: UIButton) {
        sendEvent(Analytics.finishOnboarding, withProperties: nil)
        let controller = UIStoryboard(name: Storyboards.split.rawValue, bundle: nil).instantiateInitialViewController()!
        try! Database.manager.data.write {
            Database.manager.application.isShowWelcome = true
        }
        self.present(controller, animated: true, completion: nil)
    }
}
