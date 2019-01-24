//
//  IconCollectionViewCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    // MARK: - UI
    @IBOutlet weak var iconImage: UIImageView!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImage.clipsToBounds = true
        self.iconImage.layer.cornerRadius = 10.0
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10.0
    }
}
