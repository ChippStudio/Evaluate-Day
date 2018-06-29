//
//  WeatherValue.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherValue: Object {
    // MARK: - General
    @objc dynamic var id = UUID.id
    @objc dynamic var owner: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    
    // MARK: - Weather specific
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var temperarure: Double = 0.0
    @objc dynamic var apparentTemperature: Double = 0.0
    @objc dynamic var summary: String = ""
    @objc dynamic var icon: String = ""
    @objc dynamic var humidity: Double = 0.0
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var windSpeed: Double = 0.0
    @objc dynamic var cloudCover: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct WeatherKey {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let temperature = "temperature"
    static let apparentTemperature = "apparentTemperature"
    static let summary = "summary"
    static let icon = "icon"
    static let humidity = "humidity"
    static let pressure = "pressure"
    static let windSpeed = "windSpeed"
    static let cloudCover = "cloudCover"
}
