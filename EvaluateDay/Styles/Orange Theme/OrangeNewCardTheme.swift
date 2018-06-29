//
//  DarkNewCardTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

struct OrangeNewCardTheme: NewCardStyle {
    // General controller
    var background: UIColor { return UIColor.squash }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    // Card source node
    var sourceTitleColor: UIColor { return UIColor.paleGrey }
    var sourceSubtitleColor: UIColor { return UIColor.grapePurple }
    var sourceTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .demiBold) }
    var sourceSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var sourceUntouchableColor: UIColor { return UIColor.lightGray }
}
