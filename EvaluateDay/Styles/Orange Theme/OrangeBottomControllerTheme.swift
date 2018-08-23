//
//  DarkBottomControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeBottomControllerTheme: BottomViewControllerStyle {
    
    var maskColor: UIColor { return UIColor.black }
    var maskAlpha: CGFloat { return 0.75 }
    var bottomViewColor: UIColor { return UIColor.pumpkin }
    var closeButtonColor: UIColor { return UIColor.white }
    
    // MARK: - ReorderBottomViewControllerStyle
    var reorderCellTextColor: UIColor { return UIColor.paleGrey }
    var reorderCellTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    
    // MARK: - TimeBottomViewControllerStyle
    var timeBottomViewTintColor: UIColor { return UIColor.paleGrey }
}
