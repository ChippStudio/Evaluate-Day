//
//  Cards.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import SwiftyJSON
import IGListKit
import CloudKit
import RealmSwift

protocol Evaluable {
    var card: Card! { get set }
    var evaluateSectionController: ListSectionController { get }
    
    func deleteValues()
    func hasEvent(forDate date: Date) -> Bool
    func textExport() -> String
}

protocol Editable {
    var sectionController: ListSectionController { get }
    var card: Card! { get set }
    var canSave: Bool { get }
}

protocol Mergeable {
    var mergeableSectionController: ListSectionController { get }
    var card: Card! { get set }
}

protocol Analytical {
    var analyticalSectionController: ListSectionController { get }
    var card: Card! { get set }
}

protocol CardNode {
    var title: TitleNode! { get set }
}
