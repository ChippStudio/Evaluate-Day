//
//  CollectionImageTableViewCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class CollectionImageTableViewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var collectionImageView: UIImageView!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.collectionImageView.layer.cornerRadius = 10.0
        self.collectionImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
