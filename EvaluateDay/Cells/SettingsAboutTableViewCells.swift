//
//  SettingsAboutTableViewCells.swift
//  EvaluateDay
//
//  Created by Konstantin Chistyakov on 25/07/16.
//  Copyright © 2016 Madmind Studio. All rights reserved.
//

import UIKit

class SettingsAboutTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
}

class SettingsAboutSocialTableViewCell: UITableViewCell {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.facebookButton.layer.cornerRadius = 20
        self.facebookButton.layer.borderWidth = 1
        self.facebookButton.tag = 0
        
        self.instagramButton.layer.cornerRadius = 20
        self.instagramButton.layer.borderWidth = 1
        self.instagramButton.tag = 1
        
        self.linkedinButton.layer.cornerRadius = 20
        self.linkedinButton.layer.borderWidth = 1
        self.linkedinButton.tag = 2
        
        self.githubButton.layer.cornerRadius = 20
        self.githubButton.layer.borderWidth = 1
        self.githubButton.tag = 3
        
        self.mailButton.layer.cornerRadius = 20
        self.mailButton.layer.borderWidth = 1
        self.mailButton.tag = 4
    }
}

class SettingsAboutShareTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var share: UIImageView!
}

class SettingsLogoTableViewCell: UITableViewCell {
    @IBOutlet weak var logo: UIImageView!
}

class SettingsAboutSpecialThanksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var specialImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var email: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.email.contentInset = UIEdgeInsets(top: -10.0, left: -5.0, bottom: 10.0, right: 0.0)
        
        self.descriptionLabel.numberOfLines = 0
    }
}
