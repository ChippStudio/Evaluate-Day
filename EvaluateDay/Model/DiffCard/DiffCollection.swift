//
//  DiffCollection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class DiffCollection: NSObject {

    // MARK: - Collection
    let data: Dashboard
    
    // MARK: - Collection properties
    let id: String
    
    // MARK: - Init
    init(collection: Dashboard) {
        self.data = collection
        
        // init properties
        self.id = collection.id
        
        // Super init
        super.init()
    }
}

extension DiffCollection: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
