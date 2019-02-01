//
//  LocationListCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class LocationListCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var otherAddress: UILabel!
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.street.textColor = UIColor.text
        self.otherAddress.textColor = UIColor.text
        self.coordinates.textColor = UIColor.text
        self.dateLabel.textColor = UIColor.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
