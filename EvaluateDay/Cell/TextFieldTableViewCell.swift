//
//  TextFieldTableViewCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    // MARK: - UI
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
