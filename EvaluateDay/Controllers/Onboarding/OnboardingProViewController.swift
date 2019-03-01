//
//  OnboardingProViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/03/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class OnboardingProViewController: UIViewController {

    // MARK: - UI
    var skipButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var proView: ProView!
    
    // MARK: - Variables
    private let enjoySegue = "enjoySegue"
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.skipButton = UIBarButtonItem(title: Localizations.General.skip, style: .plain, target: self, action: #selector(self.skipButtonAction(seneder:)))
        self.navigationItem.rightBarButtonItem = self.skipButton
        
        self.imageView.layer.cornerRadius = 10.0
        
        self.proView.button.addTarget(self, action: #selector(self.proButtonAction(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    @objc func skipButtonAction(seneder: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.enjoySegue, sender: self)
    }
    
    @IBAction func proButtonAction(_ sender: Any) {
        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
