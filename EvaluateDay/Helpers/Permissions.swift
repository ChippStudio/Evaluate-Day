//
//  Permissions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/01/2017.
//  Copyright © 2017 Chipp Studio. All rights reserved.
//

import Foundation
import CoreLocation
import Photos
import UserNotifications

class Permissions: NSObject {
    
    // MARK: - Singleton
    static let defaults = Permissions()
    
    // MARK: - Observable
    var locationStatus = CLAuthorizationStatus.notDetermined
    var cameraStatus = AVAuthorizationStatus.notDetermined
    var photoStatus = PHAuthorizationStatus.notDetermined
    var notificationStatus = UNAuthorizationStatus.notDetermined
    
    // MARK: - Variable
    var currentLocation: CLLocation?
    private var locationAutorizationCompletion: (() -> Void)?
    
    // MARK: - Private
    private let locationManager = CLLocationManager()
    
    // MARK: - Activate
    func activate() {
        // Set location authorization status
        self.locationStatus = CLLocationManager.authorizationStatus()
        self.locationManager.delegate = self
        
        if locationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        // Set camera and mic autorization status
        self.cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        self.photoStatus = PHPhotoLibrary.authorizationStatus()
        
        // Set notification autorization status
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            self.notificationStatus = settings.authorizationStatus
        }
        
        // Set notification
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(sender:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: - Private Init
    private override init() {
        super.init()
    }
    
    // MARK: - Actions
    func openAppSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Location Actions
    /// Key in info.plist - NSLocationWhenInUseUsageDescription
    func locationAuthorize(completion: (() -> Void)?) {
        if locationStatus == .denied || locationStatus == .restricted {
            self.openAppSettings()
        } else {
            self.locationAutorizationCompletion = completion
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLocation() {
        if locationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func distanceFrom(location: CLLocation?) -> CLLocationDistance? {
        if currentLocation == nil || location == nil {
            return nil
        }
        return currentLocation!.distance(from: location!)
    }
    
    // MARK: - Camera and mic actions
    /// Key in info.plist - NSCameraUsageDescription
    func cameraAutorize(completion: (() -> Void)?) {
        if cameraStatus == .denied || cameraStatus == .restricted {
            self.openAppSettings()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (_) in
                OperationQueue.main.addOperation({
                    self.cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                    if self.cameraStatus == .authorized {
                        completion?()
                    }
                })
            }
        }
    }
    
    /// Key in info.plist - NSPhotoLibraryAddUsageDescription
    func photoAutorize(completion: (() -> Void)?) {
        if photoStatus == .denied || photoStatus == .restricted {
            self.openAppSettings()
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                OperationQueue.main.addOperation {
                    self.photoStatus = status
                    if status == .authorized {
                        completion?()
                    }
                }
            }
        }
    }
    
    // MARK: - Notifications action
    func notificationAutorize(completion: (() -> Void)?) {
        if notificationStatus == .denied {
            self.openAppSettings()
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, _) in
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    self.notificationStatus = settings.authorizationStatus
                    if granted {
                        OperationQueue.main.addOperation {
                            UIApplication.shared.registerForRemoteNotifications()
                            completion?()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Private actions
    @objc private func applicationDidBecomeActive(sender: Notification) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            self.notificationStatus = settings.authorizationStatus
        }
        self.cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        self.photoStatus = PHPhotoLibrary.authorizationStatus()
        self.locationStatus = CLLocationManager.authorizationStatus()
    }
}

extension Permissions: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            self.locationManager.stopUpdatingLocation()
            currentLocation = loc
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        if locationStatus == .authorizedWhenInUse {
            self.locationAutorizationCompletion?()
            self.locationAutorizationCompletion = nil
        }
        if self.currentLocation == nil {
            self.updateLocation()
        }
    }
}
