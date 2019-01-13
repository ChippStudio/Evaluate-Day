//
//  NewCardTableViewCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class NewCardCell: UITableViewCell {

    // MARK: - UI
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.titleLabel.textColor = UIColor.text
        self.subtitleLabel.textColor = UIColor.main
        
        self.iconImageView.tintColor = UIColor.main
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
