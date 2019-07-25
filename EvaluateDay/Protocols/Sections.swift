//
//  Sections.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Activity
protocol ActivitySection { }

// MARK: - Evaluable
protocol EvaluableSection {
    // MARK: - Variables
    var card: Card! { get set }
    var date: Date! { get set }
    
    // MARK: - Handlers
    var didSelectItem: ((_ section: Int, _  bcard: Card) -> Void)? { get set }
    
    // MARK: - Actions
    func performAction(for shortcut: SiriShortcutItem)
}

// MARK: - Analytical
protocol AnalyticalSection {
    // MARK: - Variables
    var card: Card! { get set }
    
    // MARK: - Handlers
    var exportHandler: ((_ indexPath: IndexPath, _ index: Int, _ item: Any) -> Void)? { get set }
}

// MARK: - Editable
protocol EditableSection {
    // MARK: - Variables
    var card: Card! { get set }
    
    // MARK: - Handlers
    var setTextHandler: ((_ title: String, _ property: String, _ oldText: String?) -> Void)? { get set }
    var setBoolHandler: ((_ isOn: Bool, _ property: String, _ oldIsOn: Bool) -> Void)? { get set }
}

// MARK: - Merge
protocol MergeSection {
    // MARK: - Variables
    var card: Card! { get set }
    
    // MARK: - Handlers
    var mergeDone: (() -> Void)? { get set }
}
