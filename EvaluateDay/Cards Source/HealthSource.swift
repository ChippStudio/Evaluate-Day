//
//  HealthSource.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import HealthKit

struct HealthSource {
    // MARK: - Parameters
    let type: HKObjectType
    
    // MARK: - Init
    init(type: HKObjectType) {
        self.type = type
    }
    
    // MARK: - Calculated parameters
    var localizedString: String {
        get {
            let typeKey = self.type.identifier
            return NSLocalizedString("health.id.\(typeKey)", comment: "\(typeKey)")
        }
    }
}
