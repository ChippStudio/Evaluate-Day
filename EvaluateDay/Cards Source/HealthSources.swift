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
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceCycling) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .flightsClimbed) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceSwimming) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .distanceWheelchair) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .nikeFuel) {
            self.sources.append(HealthSource(type: h))
        }
    }
    
    private func setNutriationSources() {
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryWater) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietarySugar) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .dietaryProtein) {
            self.sources.append(HealthSource(type: h))
        }
    }
    
    private func setSleepSources() {
        if let h = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            self.sources.append(HealthSource(type: h))
        }
    }
    
    private func setMindfulnessSouerces() {
        if let h = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
            self.sources.append(HealthSource(type: h))
        }
    }
    
    private func setBodySources() {
        if let h = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .bodyMassIndex) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .bodyMass) {
            self.sources.append(HealthSource(type: h))
        }
        if let h = HKObjectType.quantityType(forIdentifier: .leanBodyMass) {
            self.sources.append(HealthSource(type: h))
        }
    }
}
