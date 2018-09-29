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
    let type: HealthType
    
    // MARK: - Init
    init(type: HealthType) {
        self.type = type
    }
    
    // MARK: - Calculated parameters
    var localizedString: String {
        get {
            let typeKey = self.type.rawValue
            return NSLocalizedString("health.id.\(typeKey)", comment: "\(typeKey)")
        }
    }
    
    var unit: HKUnit? {
        get {
            switch self.type {
            case .steps:
                return HKUnit.count()
            case .walkingDistance:
                return HKUnit.meter()
            default:
                return nil
            }
        }
    }
    
    var queryType: HealthQueryType? {
        get {
            switch self.type {
            case .steps:
                return .statistics
            case .walkingDistance:
                return .statistics
            default:
                return nil
            }
        }
    }
    
    var objectType: HKObjectType? {
        get {
            if type == .mindfull || self.type == .sleep {
                return HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: type.rawValue))
            }
            
            return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: type.rawValue))
        }
    }
}

enum HealthType: String {
    case steps = "HKQuantityTypeIdentifierStepCount"
    case walkingDistance = "HKQuantityTypeIdentifierDistanceWalkingRunning"
    case cyclingDistance = "HKQuantityTypeIdentifierDistanceCycling"
    case climbed = "HKQuantityTypeIdentifierFlightsClimbed"
    case activeEnergy = "HKQuantityTypeIdentifierActiveEnergyBurned"
    case basalEnergy = "HKQuantityTypeIdentifierBasalEnergyBurned"
    case exerciseTime = "HKQuantityTypeIdentifierAppleExerciseTime"
    case swimmingDistance = "HKQuantityTypeIdentifierDistanceSwimming"
    case swimmingStrokes = "HKQuantityTypeIdentifierSwimmingStrokeCount"
    case wheelchairDistance = "HKQuantityTypeIdentifierDistanceWheelchair"
    case nikeFuel = "HKQuantityTypeIdentifierNikeFuel"
    case bodyFatPercentage = "HKQuantityTypeIdentifierBodyFatPercentage"
    case bodyMassIndex = "HKQuantityTypeIdentifierBodyMassIndex"
    case weight = "HKQuantityTypeIdentifierBodyMass"
    case leanBodyMass = "HKQuantityTypeIdentifierLeanBodyMass"
    case caffeine = "HKQuantityTypeIdentifierDietaryCaffeine"
    case water = "HKQuantityTypeIdentifierDietaryWater"
    case energyConsumer = "HKQuantityTypeIdentifierDietaryEnergyConsumed"
    case sugar = "HKQuantityTypeIdentifierDietarySugar"
    case fatTotal = "HKQuantityTypeIdentifierDietaryFatTotal"
    case proteine = "HKQuantityTypeIdentifierDietaryProtein"
    case sleep = "HKCategoryTypeIdentifierSleepAnalysis"
    case mindfull = "HKCategoryTypeIdentifierMindfulSession"
}

enum HealthQueryType {
    case sample
    case statistics
}
