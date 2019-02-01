//
//  MarkListCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class MarkListCell: UITableViewCell {

    // MARK: - UI
    
    @IBOutlet weak var markImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.markImage.image = Images.Media.done.image.withRenderingMode(.alwaysTemplate)
        self.markImage.tintColor = UIColor.main
        
        self.commentLabel.textColor = UIColor.main
        self.dateLabel.textColor = UIColor.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
