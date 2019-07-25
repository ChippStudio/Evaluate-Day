//
//  SettingsSiriEditShortcutCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/07/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SettingsSiriEditShortcutCell: UITableViewCell {

    // MARK: - UI

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var siriLabel: UILabel!
    @IBOutlet weak var siriDoneIcon: UIImageView!
    @IBOutlet weak var siriCover: UIView!
    @IBOutlet weak var phrase: UILabel!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = UIColor.text
        
        self.siriCover.backgroundColor = UIColor.background
        self.siriCover.layer.cornerRadius = 8.0
        self.siriCover.layer.borderWidth = 1.0
        self.siriCover.layer.borderColor = UIColor.main.cgColor
        
        self.siriLabel.text = Localizations.Siri.Settings.added
        self.siriLabel.textColor = UIColor.text
        
        self.phrase.textColor = UIColor.main
        
        self.siriDoneIcon.image = Images.Media.siriCheckmark.image.withRenderingMode(.alwaysTemplate)
        self.siriDoneIcon.tintColor = UIColor.inverseBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
