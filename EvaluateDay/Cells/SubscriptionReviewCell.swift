//
//  SubscriptionReviewCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 21/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SubscriptionReviewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var proLabel: UILabel!
    @IBOutlet weak var thankLabel: UILabel!
    @IBOutlet weak var emogiLabel: UILabel!
    @IBOutlet weak var subscriptionLabel: UILabel!
    @IBOutlet weak var validLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var manageButton: UIButton!
    @IBOutlet weak var manageButtonCover: UIView!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var eulaButton: UIButton!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set data
        self.proLabel.text = Localizations.Settings.Pro.Review.title.uppercased()
        self.thankLabel.text = Localizations.Settings.Pro.Review.subtitle
        self.subscriptionLabel.text = Localizations.Settings.Pro.Review.Subscription.title
        self.emogiLabel.text = "😍🇪🇪👍🔓"
        if let valid = Store.current.valid {
        self.validLabel.text = Localizations.Settings.Pro.Review.Subscription.subtitle(DateFormatter.localizedString(from: valid, dateStyle: .medium, timeStyle: .none))
        } else {
            self.validLabel.text = nil
        }
        
        self.informationLabel.text = Localizations.Settings.Pro.Review.Subscription.description
        self.manageButton.setTitle(Localizations.Settings.Pro.Subscription.manage, for: .normal)
        
        self.privacyButton.setTitle(Localizations.Settings.Pro.Privacy.privacy, for: .normal)
        self.eulaButton.setTitle(Localizations.Settings.Pro.Privacy.eula, for: .normal)
        
        // Set Appearance
        self.proLabel.textColor = UIColor.main
        self.thankLabel.textColor = UIColor.text
        self.subscriptionLabel.textColor = UIColor.main
        self.validLabel.textColor = UIColor.text
        self.informationLabel.textColor = UIColor.main
        self.manageButton.setTitleColor(UIColor.textTint, for: .normal)
        
        self.manageButtonCover.backgroundColor = UIColor.main
        self.manageButtonCover.layer.cornerRadius = 10.0
        self.manageButtonCover.layer.masksToBounds = true
        
        self.privacyButton.setTitleColor(UIColor.main, for: .normal)
        self.eulaButton.setTitleColor(UIColor.main, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
