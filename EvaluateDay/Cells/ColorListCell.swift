//
//  ColorListCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class ColorListCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorDot: UIView!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabel.textColor = UIColor.text
        self.colorDot.layer.masksToBounds = true
        self.colorDot.layer.cornerRadius = self.colorDot.frame.size.height/2
        self.colorDot.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
