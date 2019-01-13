//
//  ProUnlockCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class ProUnlockCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var proView: ProView!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.descriptionLabel.textColor = UIColor.main
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
