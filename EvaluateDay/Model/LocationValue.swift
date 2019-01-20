//
//  LocationValue.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import MapKit

class LocationValue: Object {
    @objc dynamic var id = UUID.id
    @objc dynamic var owner: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    
    // Location specific data
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    // Location place data
    @objc dynamic var city: String?
    @objc dynamic var country: String?
    @objc dynamic var state: String?
    @objc dynamic var street: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension LocationValue {
    var location: CLLocation {
        set {
            self.latitude = newValue.coordinate.latitude
            self.longitude = newValue.coordinate.longitude
        }
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
    var distance: CLLocationDistance {
        guard let currentLocation = Permissions.defaults.currentLocation else {
            return 0.0
        }
        
        return self.location.distance(from: currentLocation)
    }
    
    var distanceString: String {
        guard let currentLocation = Permissions.defaults.currentLocation else {
            return "0"
        }
        
        let distance = self.location.distance(from: currentLocation)
        let format = MKDistanceFormatter()
        return format.string(fromDistance: distance)
    }
    
    var streetString: String {
        get {
            if self.street != nil {
                return self.street!
            }
            
            return ""
        }
    }
    var cityString: String {
        get {
            if self.city != nil {
                return self.city!
            }
            
            return ""
        }
    }
    var stateString: String {
        get {
            if self.state != nil {
                return self.state!
            }
            
            return ""
        }
    }
    var countryString: String {
        get {
            if self.country != nil {
                return self.country!
            }
            
            return ""
        }
    }
    
    var otherAddressString: String {
        get {
            var addressString = ""
            if self.city != nil {
                addressString += self.city!
            }
            
            if self.state != nil {
                if addressString != "" {
                    addressString += ", "
                }
                addressString += self.state!
            }
            if self.country != nil {
                if addressString != "" {
                    addressString += ", "
                }
                addressString += self.country!
            }
            return addressString
        }
    }
    
    var coordinatesString: String {
        return "\(String(format: "%.6f", self.latitude)), \(String(format: "%.6f", self.longitude))"
    }
    
    var isAddresSet: Bool {
        get {
            if self.city != nil {
                return true
            } else if self.country != nil {
                return true
            } else if self.state != nil {
                return true
            } else if self.street != nil {
                return true
            }
            
            return false
        }
    }
}

extension LocationValue {
    func locationInformation(completion: ((_ street: String?, _ city: String?, _ state: String?, _ country: String?) -> Void)?) {
        CLGeocoder().reverseGeocodeLocation(self.location) { (places, _) in
            if let place = places?.first {
                completion?(place.name, place.locality, place.administrativeArea, place.country)
            } else {
                completion?(nil, nil, nil, nil)
            }
        }
    }
}
