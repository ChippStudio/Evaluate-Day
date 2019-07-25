//
//  SettingsSiriAddShortcutCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/07/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SettingsSiriAddShortcutCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var siriLabel: UILabel!
    @IBOutlet weak var siriCover: UIView!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.text
        
        self.siriLabel.textColor = UIColor.inverseText
        self.siriCover.backgroundColor = UIColor.inverseBackground
        self.siriCover.layer.cornerRadius = 8.0
        self.siriLabel.text = Localizations.Siri.Settings.add
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
