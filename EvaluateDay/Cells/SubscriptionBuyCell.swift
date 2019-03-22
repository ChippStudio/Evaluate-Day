//
//  SubscriptionBuyCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 21/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SubscriptionBuyCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var descriptionSubscriptionLabel: UILabel!
    @IBOutlet weak var moreDescriptionSubscriptionLabel: UILabel!
    @IBOutlet weak var viewMoreButton: UIButton!
    
    @IBOutlet weak var selectionCoverView: UIView!
    @IBOutlet weak var topViewCover: UIView!
    @IBOutlet weak var bottomViewCover: UIView!
    @IBOutlet weak var topDurationLabel: UILabel!
    @IBOutlet weak var bottomDurationLabel: UILabel!
    
    @IBOutlet weak var topPriceLabel: UILabel!
    @IBOutlet weak var bottomPriceLabel: UILabel!
    @IBOutlet weak var topSelectedImage: UIImageView!
    @IBOutlet weak var bottomSelectedImage: UIImageView!
    
    @IBOutlet weak var cancelDescriptionLabel: UILabel!
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var continueCover: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var oneTimeButtonCover: UIView!
    @IBOutlet weak var oneTimeButton: UIButton!
    
    @IBOutlet weak var legalNoteLabel: UILabel!
    
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var eulaButton: UIButton!
    
    // MARK: - Variable
    var isTopSelected = true {
        didSet {
            self.setSelectedColors()
        }
    }
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set data
        self.viewMoreButton.setTitle(Localizations.Settings.Pro.View.readMore, for: .normal)
        self.descriptionSubscriptionLabel.text = Localizations.Settings.Pro.Description.mainTitle
        self.moreDescriptionSubscriptionLabel.text = Localizations.Settings.Pro.Description.title
        
        self.cancelDescriptionLabel.text = Localizations.Settings.Pro.Subscription.Description.cancel
        self.restoreButton.setTitle(Localizations.Settings.Pro.restore, for: .normal)
        
        self.topDurationLabel.text = Localizations.Settings.Pro.Subscription.Title.anuualy
        self.topPriceLabel.text = Localizations.Settings.Pro.Subscription.Buy.annualy(Store.current.localizedAnnualyPrice)
        self.topSelectedImage.image = Images.Media.done.image.resizedImage(newSize: CGSize(width: 20.0, height: 20.0)).withRenderingMode(.alwaysTemplate)
        self.topSelectedImage.tintColor = UIColor.textTint
        
        self.bottomDurationLabel.text = Localizations.Settings.Pro.Subscription.Title.monthly
        self.bottomPriceLabel.text = Localizations.Settings.Pro.Subscription.Buy.monthly(Store.current.localizedMonthlyPrice)
        self.bottomSelectedImage.image = Images.Media.done.image.resizedImage(newSize: CGSize(width: 20.0, height: 20.0)).withRenderingMode(.alwaysTemplate)
        self.bottomSelectedImage.tintColor = UIColor.textTint
        
        self.continueButton.setTitle(Localizations.Settings.Pro.Subscription.Title.continue, for: .normal)
        self.oneTimeButton.setTitle(Localizations.Settings.Pro.Subscription.Title.lifetime(Store.current.localizedLifetimePrice), for: .normal)
        
        self.legalNoteLabel.text = Localizations.Settings.Pro.Subscription.Description.iTunes
        self.privacyButton.setTitle(Localizations.Settings.Pro.Privacy.privacy, for: .normal)
        self.eulaButton.setTitle(Localizations.Settings.Pro.Privacy.eula, for: .normal)
        
        // Set appearance
        self.descriptionSubscriptionLabel.textColor = UIColor.text
        self.moreDescriptionSubscriptionLabel.textColor = UIColor.text
        self.viewMoreButton.setTitleColor(UIColor.main, for: .normal)
        self.viewMoreButton.setTitleColor(UIColor.selected, for: .highlighted)
        
        self.selectionCoverView.backgroundColor = UIColor.background
        self.selectionCoverView.layer.cornerRadius = 10.0
        self.selectionCoverView.layer.borderColor = UIColor.main.cgColor
        self.selectionCoverView.layer.borderWidth = 0.5
        self.selectionCoverView.layer.masksToBounds = true
        
        self.continueButton.setTitleColor(UIColor.textTint, for: .normal)
        self.continueCover.layer.cornerRadius = 10.0
        self.continueCover.layer.masksToBounds = true
        self.continueCover.backgroundColor = UIColor.main
        
        self.oneTimeButton.setTitleColor(UIColor.textTint, for: .normal)
        self.oneTimeButtonCover.layer.cornerRadius = 10.0
        self.oneTimeButtonCover.layer.masksToBounds = true
        self.oneTimeButtonCover.backgroundColor = UIColor.main
        
        self.cancelDescriptionLabel.textColor = UIColor.main
        self.restoreButton.setTitleColor(UIColor.selected, for: .normal)
        self.restoreButton.setTitleColor(UIColor.main, for: .highlighted)
        
        self.legalNoteLabel.textColor = UIColor.main
        
        self.privacyButton.setTitleColor(UIColor.selected, for: .normal)
        self.eulaButton.setTitleColor(UIColor.selected, for: .normal)
        
        self.setSelectedColors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Actions
    private func setSelectedColors() {
        UIView.animate(withDuration: 0.2) {
            if self.isTopSelected {
                self.topViewCover.backgroundColor = UIColor.main
                self.topSelectedImage.alpha = 1.0
                self.topDurationLabel.textColor = UIColor.textTint
                self.topPriceLabel.textColor = UIColor.textTint
                
                self.bottomViewCover.backgroundColor = UIColor.background
                self.bottomSelectedImage.alpha = 0.0
                self.bottomDurationLabel.textColor = UIColor.text
                self.bottomPriceLabel.textColor = UIColor.text
                
                if Store.current.annualy != nil {
                    if #available(iOS 11.2, *) {
                        self.cancelDescriptionLabel.text = Localizations.Settings.Pro.Subscription.Description.cancel + "\n" + Store.current.annualy.introductory
                    }
                }
            } else {
                self.topViewCover.backgroundColor = UIColor.background
                self.topSelectedImage.alpha = 0.0
                self.topDurationLabel.textColor = UIColor.text
                self.topPriceLabel.textColor = UIColor.text
                
                self.bottomViewCover.backgroundColor = UIColor.main
                self.bottomSelectedImage.alpha = 1.0
                self.bottomDurationLabel.textColor = UIColor.textTint
                self.bottomPriceLabel.textColor = UIColor.textTint
                
                if Store.current.mouthly != nil {
                    if #available(iOS 11.2, *) {
                        self.cancelDescriptionLabel.text = Localizations.Settings.Pro.Subscription.Description.cancel + "\n" + Store.current.mouthly.introductory
                    }
                }
            }
        }
    }
    
    @IBAction func topSelectedButtonAction(_ sender: UIButton) {
        Feedback.player.select()
        self.isTopSelected = true
    }
    
    @IBAction func BottomSelectedButtonAction(_ sender: UIButton) {
        Feedback.player.select()
        self.isTopSelected = false
    }
}
