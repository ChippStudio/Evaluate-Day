//
//  MapAnnotation.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import MapKit

final class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var locationValue: LocationValue
    var isCurrentLocation = false
    
    init(locationValue value: LocationValue) {
        self.coordinate = value.location.coordinate
        self.locationValue = value
        super.init()
    }
}
