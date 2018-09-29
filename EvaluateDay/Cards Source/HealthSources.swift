//
//  HealthSources.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import HealthKit

enum HealthCategory {
    case fitness
    case nutrition
    case sleep
    case mindfulness
    case body
}

class HealthSources: NSObject {

    // MARK: - Variables
    let category: HealthCategory
    var title: String!
    
    var sources = [HealthSource]()
    
    // MARK: - Init
    init(category: HealthCategory) {
        self.category = category
        
        super.init()
        
        switch self.category {
        case .fitness:
            self.title = Localizations.health.category.fitness
            self.setFitnessSources()
        case .nutrition:
            self.title = Localizations.health.category.nutrition
            self.setNutriationSources()
        case .sleep:
            self.title = Localizations.health.category.sleep
            self.setSleepSources()
        case .mindfulness:
            self.title = Localizations.health.category.mindfulness
            self.setMindfulnessSouerces()
        case .body:
            self.title = Localizations.health.category.body
            self.setBodySources()
        }
    }
    
    // MARK: - Private
    private func setFitnessSources() {
        self.sources.removeAll()
        
        if let h = HKObjectType.quantityType(forIdentifier: .stepCount) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceCycling) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .flightsClimbed) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceSwimming) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceWheelchair) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .nikeFuel) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
    }
    
    private func setNutriationSources() {
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryWater) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietarySugar) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryProtein) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
    }
    
    private func setSleepSources() {
        if let h = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
    }
    
    private func setMindfulnessSouerces() {
        if let h = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
    }
    
    private func setBodySources() {
        if let h = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .bodyMassIndex) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .bodyMass) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
        if let h = HKObjectType.quantityType(forIdentifier: .leanBodyMass) {
            if let type = HealthType(rawValue: h.identifier) {
                self.sources.append(HealthSource(type: type))
            }
        }
    }
}
