//
//  CardRepresentCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class CardRepresentCell: UITableViewCell {

    // MARK: - UI
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardSubtitleLabel: UILabel!
    @IBOutlet weak var collectionTitleLabel: UILabel!
    
    @IBOutlet weak var collectionImageHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomOffset: NSLayoutConstraint!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.cardTitleLabel.textColor = UIColor.text
        self.cardSubtitleLabel.textColor = UIColor.text
        self.collectionTitleLabel.textColor = UIColor.main
        
        self.collectionImageView.layer.cornerRadius = 30/2
        self.collectionImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
