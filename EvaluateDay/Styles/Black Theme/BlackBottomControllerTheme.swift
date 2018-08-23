//
//  BlackBottomControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct BlackBottomControllerTheme: BottomViewControllerStyle {
    
    var maskColor: UIColor { return UIColor.black }
    var maskAlpha: CGFloat { return 0.7 }
    var bottomViewColor: UIColor { return UIColor.smokyBlack }
    var closeButtonColor: UIColor { return UIColor.white }
    
    // MARK: - ReorderBottomViewControllerStyle
    var reorderCellTextColor: UIColor { return UIColor.white }
    var reorderCellTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    
    // MARK: - TimeBottomViewControllerStyle
    var timeBottomViewTintColor: UIColor { return UIColor.white }
}
