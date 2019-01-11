//
//  EvaluateColorDotsAnalyticsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EvaluateColorDotsAnalyticsNode: ASCellNode {
    
    // MARK: - UI
    var dots = [ASDisplayNode]()
    var cover = ASDisplayNode()
    var disclosure = ASImageNode()
    
    // MARK: - Init
    init(colors: [String]) {
        super.init()
        
        self.automaticallyManagesSubnodes = true
    }
}
