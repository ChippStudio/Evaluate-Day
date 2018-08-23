//
//  DarkBottomControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkBottomControllerTheme: BottomViewControllerStyle {
    
    var maskColor: UIColor { return UIColor.charcoal }
    var maskAlpha: CGFloat { return 0.75 }
    var bottomViewColor: UIColor { return UIColor.gunmetal }
    var closeButtonColor: UIColor { return UIColor.white}
    
    // MARK: - ReorderBottomViewControllerStyle
    var reorderCellTextColor: UIColor { return UIColor.white }
    var reorderCellTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    
    // MARK: - TimeBottomViewControllerStyle
    var timeBottomViewTintColor: UIColor { return UIColor.white }
}
