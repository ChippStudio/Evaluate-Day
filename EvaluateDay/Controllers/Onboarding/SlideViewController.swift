//
//  SlideViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/03/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Variables
    var index: Int = 0
    var titleString: String?
    var descriptionString: String?
    var image: UIImage?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = 10.0
        
        self.titleLabel.textColor = UIColor.selected
        self.descriptionLabel.textColor = UIColor.main
        self.descriptionLabel.adjustsFontSizeToFitWidth = true
        
        self.imageView.image = self.image
        self.titleLabel.text = self.titleString
        self.descriptionLabel.text = self.descriptionString
        
        self.view.backgroundColor = UIColor.background
    }
}
