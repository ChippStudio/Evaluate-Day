//
//  WeatherValue+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 31/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import CloudKit

extension WeatherValue: CloudKitSyncable {
    func record(zoneID: CKRecordZoneID) -> CKRecord? {
        let recordId = CKRecordID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "WeatherValue", recordID: recordId)
        record.setObject(self.owner as CKRecordValue, forKey: "owner")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        // Weather
        record.setObject(self.latitude as CKRecordValue, forKey: WeatherKey.latitude)
        record.setObject(self.longitude as CKRecordValue, forKey: WeatherKey.longitude)
        record.setObject(self.temperarure as CKRecordValue, forKey: WeatherKey.temperature)
        record.setObject(self.apparentTemperature as CKRecordValue, forKey: WeatherKey.apparentTemperature)
        record.setObject(self.summary as CKRecordValue, forKey: WeatherKey.summary)
        record.setObject(self.icon as CKRecordValue, forKey: WeatherKey.icon)
        record.setObject(self.humidity as CKRecordValue, forKey: WeatherKey.humidity)
        record.setObject(self.pressure as CKRecordValue, forKey: WeatherKey.pressure)
        record.setObject(self.windSpeed as CKRecordValue, forKey: WeatherKey.windSpeed)
        record.setObject(self.cloudCover as CKRecordValue, forKey: WeatherKey.cloudCover)
        return record
    }
    
    static func object(record: CKRecord) -> WeatherValue? {
        let weatherValue = WeatherValue()
        weatherValue.id = record.recordID.recordName
        weatherValue.owner = record.object(forKey: "owner") as! String
        weatherValue.created = record.object(forKey: "created") as! Date
        weatherValue.edited = record.object(forKey: "edited") as! Date
        // weather
        weatherValue.latitude = record.object(forKey: WeatherKey.latitude) as! Double
        weatherValue.longitude = record.object(forKey: WeatherKey.longitude) as! Double
        weatherValue.temperarure = record.object(forKey: WeatherKey.temperature) as! Double
        weatherValue.apparentTemperature = record.object(forKey: WeatherKey.apparentTemperature) as! Double
        weatherValue.summary = record.object(forKey: WeatherKey.summary) as! String
        weatherValue.icon = record.object(forKey: WeatherKey.icon) as! String
        weatherValue.humidity = record.object(forKey: WeatherKey.humidity) as! Double
        weatherValue.pressure = record.object(forKey: WeatherKey.pressure) as! Double
        weatherValue.windSpeed = record.object(forKey: WeatherKey.windSpeed) as! Double
        weatherValue.cloudCover = record.object(forKey: WeatherKey.cloudCover) as! Double
        return weatherValue
    }
    
    typealias CloudKitSyncable = WeatherValue
}
