//
//  EntryViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Alamofire
import SwiftyJSON
import CoreLocation

class EntryViewController: UIViewController, ASTableDataSource, ASTableDelegate, SelectMapViewControllerDelegate, TimeBottomViewControllerDelegate, ASEditableTextNodeDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    var deleteButton: UIBarButtonItem!
    
    // MARK: - Variables
    var textValue: TextValue!
    var card: Card!
    
    var new: Bool = false
    
    private var lock = false
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        // Delete button
        self.deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.deleteAction(sender:)))
        self.navigationItem.rightBarButtonItem = deleteButton
        
        // Lock
        if self.textValue.created.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro {
            self.lock = true
        }
        
        self.deleteButton.isEnabled = !self.lock
        
        // Set table node
        self.tableNode = ASTableNode(style: .plain)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.showsVerticalScrollIndicator = false
        self.tableNode.view.showsHorizontalScrollIndicator = false
        self.view.addSubnode(self.tableNode)
        self.tableNode.view.keyboardDismissMode = .interactive
        
        self.observable()
        
        if self.textValue.location == nil {
            self.quickCheckIn(sender: ASButtonNode())
        }
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        
        sendEvent(.openEntry, withProperties: ["new": self.new])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.traitCollection.userInterfaceIdiom == .pad && self.view.frame.size.width >= maxCollectionWidth {
            self.tableNode.frame = CGRect(x: self.view.frame.size.width / 2 - maxCollectionWidth / 2, y: 0.0, width: maxCollectionWidth, height: self.view.frame.size.height)
        } else {
            self.tableNode.frame = self.view.bounds
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.timer != nil {
            self.timer!.fire()
        }
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 5
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            // Photos
            if self.textValue.photos.count == 0 {
                return 1
            }
            return 2
        case 2:
            // Date
            return 1
        case 3:
            // Locations
            if self.textValue.location != nil {
                return 2
            }
            return 1
        case 4:
            // Weather
            if self.textValue.weather != nil {
                return 1
            }
            return 0
        default:
            return 0
        }
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.entryControllerStyle
        switch indexPath.section {
        case 0:
            let text = self.textValue.text
            let height = self.view.frame.size.height * 2/3
            return {
                let node = TextNode(text: text, placeholder: Localizations.evaluate.journal.entry.placeholder, height: height, style: style)
                node.selectionStyle = .none
                node.textNode.delegate = self
                return node
            }
        case 1:
            if self.textValue.photos.count == 0 {
                return {
                    let node = ActionsNode(actions: [ActionsNodeAction.camera, ActionsNodeAction.photo], style: style)
                    for action in node.actions {
                        action.addTarget(self, action: #selector(self.actionNodeActions(sender:)), forControlEvents: .touchUpInside)
                    }
                    node.selectionStyle = .none
                    return node
                }
            } else {
                if indexPath.row == 0 {
                    let photo = self.textValue.photos.first!.image
                    return {
                        return PhotoNode(photo: photo)
                    }
                } else {
                    return {
                        let node = ActionsNode(actions: [ActionsNodeAction.camera, ActionsNodeAction.photo, ActionsNodeAction.delete], style: style)
                        for action in node.actions {
                            action.addTarget(self, action: #selector(self.actionNodeActions(sender:)), forControlEvents: .touchUpInside)
                        }
                        node.selectionStyle = .none
                        return node
                    }
                }
            }
        case 2:
            let date = self.textValue.created
            return {
                let node = DateNode(date: date, style: style)
                return node
            }
        case 3:
            if let loc = self.textValue.location {
                if indexPath.row == 0 {
                    let street = loc.streetString
                    let otherAdress = loc.otherAddressString
                    let coordinates = loc.coordinatesString
                    return {
                        let node = CheckInDataEvaluateNode(street: street, otherAddress: otherAdress, coordinates: coordinates, style: style)
                        node.selectionStyle = .none
                        return node
                    }
                }
            }
            
            if Permissions.defaults.locationStatus == .authorizedWhenInUse {
                return {
                    let node = CheckInActionNode(style: style)
                    if !self.lock {
                        node.mapButton.addTarget(self, action: #selector(self.openMap(sender:)), forControlEvents: .touchUpInside)
                        node.checkInButton.addTarget(self, action: #selector(self.quickCheckIn(sender:)), forControlEvents: .touchUpInside)
                    }
                    node.selectionStyle = .none
                    return node
                }
            } else {
                return {
                    let node = CheckInPermissionNode(style: style)
                    if !self.lock {
                        node.mapButton.addTarget(self, action: #selector(self.openMap(sender:)), forControlEvents: .touchUpInside)
                        node.permissionButton.addTarget(self, action: #selector(self.allowLocation(sender:)), forControlEvents: .touchUpInside)
                    }
                    node.selectionStyle = .none
                    return node
                }
            }
        case 4:
            let w = self.textValue.weather!
            var icon = UIImage(named: w.icon)
            var data = [String]()
            var temperature = "\(String(format: "%.0f", w.temperarure)) ℃"
            var apparentTemperature = "\(String(format: "%.0f", w.apparentTemperature)) ℃"
            if !Database.manager.application.settings.celsius {
                temperature = "\(String(format: "%.0f", (w.temperarure * (9/5) + 32))) ℉"
                apparentTemperature = "\(String(format: "%.0f", (w.apparentTemperature * (9/5) + 32))) ℉"
            }
            data.append(temperature)
            data.append(apparentTemperature)
        
            let humidity = String(format: "%.0f", w.humidity * 100) + " %"
            data.append(humidity)
            
            let pressure = String(format: "%.1f", w.pressure) + " mBar"
            data.append(pressure)
            
            var windSpeed = String(format: "%.1f", w.windSpeed) + " m/s"
            if !Locale.current.usesMetricSystem {
                windSpeed = String(format: "%.1f", w.windSpeed * (25/11)) + " mi/hr"
            }
            data.append(windSpeed)
            
            let cc = String(format: "%.1f", w.cloudCover * 100) + " %"
            data.append(cc)
            
            var text = Localizations.evaluate.journal.entry.weather(value1: temperature, apparentTemperature, humidity, pressure, windSpeed, cc)
            
            if w.pressure == 0.0 && w.humidity == 0.0 {
                data.removeAll()
                text = Localizations.evaluate.weather.unknown
                icon = #imageLiteral(resourceName: "clear-day")
            }
            return {
                let node = WeatherNode(icon: icon, text: text, data: data, style: style)
                node.selectionStyle = .none
                return node
            }
        default:
            return {
                return ASCellNode()
            }
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        if self.lock {
            return
        }
        
        if indexPath.section == 2 {
            let controller = TimeBottomViewController()
            controller.pickerMode = .dateAndTime
            controller.date = self.textValue.created
            controller.maximumDate = Date()
            controller.delegate = self
            controller.closeByTap = true
            
            if !Store.current.isPro {
                var components = DateComponents()
                components.day = -pastDaysLimit
                controller.minumumDate = Calendar.current.date(byAdding: components, to: Date().start)
            }
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - TimeBottomViewControllerDelegate
    func didSelectTime(inDate date: Date) {
        self.setNewDate(date: date)
    }
    
    // MARK: - SelectMapViewControllerDelegate
    func selectLocation(controller: SelectMapViewController, locationValue value: LocationValue?) {
        guard let location = self.textValue.location, let nvalue = value else {
            if value == nil || value?.realm == nil {
                return
            }
            value!.owner = self.textValue.id
            try! Database.manager.data.write {
                Database.manager.data.add(value!)
            }
            
            return
        }
        
        let locationValue = LocationValue()
        locationValue.id = location.id
        locationValue.owner = location.owner
        locationValue.created = location.created
        locationValue.edited = Date()
        locationValue.location = nvalue.location
        
        locationValue.city = nvalue.city
        locationValue.country = nvalue.country
        locationValue.state = nvalue.state
        locationValue.street = nvalue.street
        
        try! Database.manager.data.write {
            Database.manager.data.add(locationValue, update: true)
        }
        
        self.tableNode.reloadSections(IndexSet(integer: 3), with: .automatic)
        self.updateWeatherInformation()
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func deleteLocation(controller: SelectMapViewController, locationValue value: LocationValue?) {
        guard let location = self.textValue.location else {
            return
        }
        
        if location.realm == nil {
            return
        }
        
        try! Database.manager.data.write {
            location.isDeleted = true
        }
        
        self.tableNode.reloadSections(IndexSet(integer: 3), with: .automatic)
        
        guard let weather = self.textValue.weather else {
            return
        }
        
        try! Database.manager.data.write {
            weather.isDeleted = true
        }
        
        self.tableNode.reloadSections(IndexSet(integer: 4), with: .automatic)
    }
    
    // MARK: - ASEditableTextNodeDelegate
    private var timer: Timer?
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        if self.timer != nil {
            timer?.invalidate()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            try! Database.manager.data.write {
                if editableTextNode.attributedText != nil {
                    self.textValue.text = editableTextNode.attributedText!.string
                }
            }
        })
    }
    
    func editableTextNodeShouldBeginEditing(_ editableTextNode: ASEditableTextNode) -> Bool {
        return !self.lock
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            var mainAsset: PHAsset?
            if #available(iOS 11.0, *) {
                if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                    mainAsset = asset
                }
            } else {
                // Fallback on earlier versions
                if let assetURL = info[UIImagePickerControllerReferenceURL] as? String {
                    let url = URL(fileURLWithPath: assetURL)
                    if let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {
                        mainAsset = asset
                    }
                }
            }
            
            if let photo = self.textValue.photos.first {
                photo.image = image
                try! Database.manager.data.write {
                    photo.edited = Date()
                }
            } else {
                let photo = PhotoValue()
                photo.owner = self.textValue.id
                photo.image = image
                
                try! Database.manager.data.write {
                    Database.manager.data.add(photo)
                }
            }
            
            self.tableNode.reloadSections(IndexSet(integer: 1), with: .automatic)
            
            if mainAsset != nil {
                let date = mainAsset!.creationDate
                let loc = mainAsset!.location
                
                if date == nil {
                    return
                } else {
                    if date!.days(to: Date()) < 1 {
                        return
                    }
                }
                
                if loc != nil {
                    if let currentLocation = Permissions.defaults.currentLocation.value {
                        if loc!.distance(from: currentLocation) < 500 {
                            return
                        }
                    }
                }
                
                var partTitle = ""
                var message = ""
                if date != nil {
                    partTitle = Localizations.evaluate.journal.entry.photo.date
                    message = DateFormatter.localizedString(from: date!, dateStyle: .medium, timeStyle: .short)
                }
                if partTitle != "" {
                    partTitle += " \(Localizations.general.and) "
                }
                if loc != nil {
                    partTitle += Localizations.evaluate.journal.entry.photo.location
                }
                
                let title = Localizations.evaluate.journal.entry.photo.question(value1: partTitle)
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: Localizations.general.cancel, style: .cancel, handler: nil)
                let dateAction = UIAlertAction(title: Localizations.evaluate.journal.entry.photo.date, style: .default, handler: { (_) in
                    
                    self.setNewDate(date: date!)
                })
                let locationAction = UIAlertAction(title: Localizations.evaluate.journal.entry.photo.location, style: .default, handler: { (_) in
                    self.setNewLocation(location: loc!)
                })
                let bothAction = UIAlertAction(title: Localizations.evaluate.journal.entry.photo.useBoth, style: .default, handler: { (_) in
                    
                    self.setNewLocation(location: loc!)
                    self.setNewDate(date: date!)
                })
                
                if date != nil {
                    alert.addAction(dateAction)
                }
                if loc != nil {
                    alert.addAction(locationAction)
                }
                if date != nil && loc != nil {
                    alert.addAction(bothAction)
                }
                alert.addAction(cancelAction)
                
                alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
                alert.view.layoutIfNeeded()
                
                if loc == nil {
                    self.present(alert, animated: true) {
                        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
                    }
                } else {
                    CLGeocoder().reverseGeocodeLocation(loc!, completionHandler: { (places, _) in
                        if let place = places?.first {
                            message += "\n"
                            if place.name != nil {
                                message += place.name!
                            }
                            if place.locality != nil {
                                message += ", " + place.locality!
                            }
                            if place.administrativeArea != nil {
                                message += ", " + place.administrativeArea!
                            }
                            if place.country != nil {
                                message += ", " + place.country!
                            }
                            alert.message = message
                            self.present(alert, animated: true) {
                                alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
                            }
                        }
                    })
                }
            } else {
                if Database.manager.application.settings.cameraRoll {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
        }
    }
    
    // MARK: - Actions
    func updateWeatherInformation() {
        guard let location =  self.textValue.location else {
            return
        }
        
        let url = "\(weatherLink)\(location.latitude),\(location.longitude),\(Int(self.textValue.created.timeIntervalSince1970))"
        let urlParams = ["units": "si", "exclude": "[hourly, daily, flags]"]
        
        Alamofire.request(url, method: .get, parameters: urlParams).responseJSON { (response) in
            if response.error != nil {
                print("Weather responce error - \(response.error!.localizedDescription)")
                if self.textValue.weather == nil {
                    let weatherValue = WeatherValue()
                    weatherValue.owner = self.textValue.id
                    weatherValue.edited = Date()
                    
                    weatherValue.latitude = location.latitude
                    weatherValue.longitude = location.longitude
                    try! Database.manager.data.write {
                        Database.manager.data.add(weatherValue, update: true)
                    }
                    
                    self.tableNode.reloadSections(IndexSet(integer: 4), with: .automatic)
                }
                
                return
            }
            
            let json = JSON(response.data!)["currently"]
            
            let id: String
            let created: Date
            if let weather = self.textValue.weather {
                id = weather.id
                created = weather.created
            } else {
                id = UUID.id
                created = Date()
            }
            
            let weatherValue = WeatherValue()
            weatherValue.id = id
            weatherValue.created = created
            weatherValue.owner = self.textValue.id
            weatherValue.edited = Date()
            
            weatherValue.latitude = location.latitude
            weatherValue.longitude = location.longitude
            weatherValue.temperarure = json[WeatherKey.temperature].doubleValue
            weatherValue.apparentTemperature = json[WeatherKey.apparentTemperature].doubleValue
            weatherValue.summary = json[WeatherKey.summary].stringValue
            weatherValue.icon = json[WeatherKey.icon].stringValue
            weatherValue.humidity = json[WeatherKey.humidity].doubleValue
            weatherValue.pressure = json[WeatherKey.pressure].doubleValue
            weatherValue.windSpeed = json[WeatherKey.windSpeed].doubleValue
            weatherValue.cloudCover = json[WeatherKey.cloudCover].doubleValue
            
            try! Database.manager.data.write {
                Database.manager.data.add(weatherValue, update: true)
            }
            
            self.tableNode.reloadSections(IndexSet(integer: 4), with: .automatic)
            
        }
    }
    
    @objc func actionNodeActions(sender: ASButtonNode) {
        if self.lock {
            return
        }
        if let action = ActionsNodeAction(rawValue: sender.view.tag) {
            switch action {
            case .camera, .photo:
                if action == .photo && Permissions.defaults.photoStatus != .authorized {
                    Permissions.defaults.photoAutorize(completion: {
                        self.openPhotoPicker(withType: .photoLibrary)
                    })
                    return
                }
                if action == .camera && Permissions.defaults.cameraStatus != .authorized {
                    Permissions.defaults.cameraAutorize(completion: {
                        self.openPhotoPicker(withType: .camera)
                    })
                    return
                }
                
                var actionType = UIImagePickerControllerSourceType.camera
                if action == .photo {
                    actionType = .photoLibrary
                }
                
                self.openPhotoPicker(withType: actionType)
            case .delete:
                if let photo = self.textValue.photos.first {
                    try! Database.manager.data.write {
                        photo.isDeleted = true
                    }
                    
                    self.tableNode.reloadSections(IndexSet(integer: 1), with: .automatic)
                }
            default:
                return
            }
        }
    }
    
    private func openPhotoPicker(withType type: UIImagePickerControllerSourceType) {
        let photoController = UIImagePickerController()
        photoController.sourceType = type
        photoController.delegate = self
        self.present(photoController, animated: true, completion: nil)
    }
    
    @objc func allowLocation(sender: ASButtonNode) {
        Permissions.defaults.locationAuthorize {
            self.tableNode.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
    }
    
    @objc func openMap(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.selectMap.rawValue, bundle: nil).instantiateInitialViewController() as! SelectMapViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func quickCheckIn(sender: ASButtonNode) {
        guard let currentLocation = Permissions.defaults.currentLocation.value else {
            return
        }
        
        self.setNewLocation(location: currentLocation)
    }
    
    @objc func deleteAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Localizations.general.sureQuestion, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: Localizations.general.cancel, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: Localizations.general.delete, style: .destructive) { (_) in
            if self.textValue.location != nil {
                try! Database.manager.data.write {
                    self.textValue.location!.isDeleted = true
                }
            }
            if self.textValue.weather != nil {
                try! Database.manager.data.write {
                    self.textValue.weather!.isDeleted = true
                }
            }
            
            try! Database.manager.data.write {
                for p in self.textValue.photos {
                    p.isDeleted = true
                }
                
                self.textValue.isDeleted = true
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alert.popoverPresentationController?.barButtonItem = self.deleteButton
            alert.popoverPresentationController?.sourceView = self.view
        }
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        }
    }
    
    func setNewLocation(location: CLLocation) {
        let id: String
        let created: Date
        if let loc = self.textValue.location {
            id = loc.id
            created = loc.created
        } else {
            id = UUID.id
            created = Date()
        }
        
        let locationValue = LocationValue()
        locationValue.id = id
        locationValue.created = created
        locationValue.owner = self.textValue.id
        locationValue.edited = Date()
        
        locationValue.location = location
        locationValue.locationInformation { (street, city, state, country) in
            locationValue.street = street
            locationValue.city = city
            locationValue.state = state
            locationValue.country = country
            
            try! Database.manager.data.write {
                Database.manager.data.add(locationValue, update: true)
            }
            
            self.tableNode.reloadSections(IndexSet(integer: 3), with: .automatic)
            self.updateWeatherInformation()
        }
    }
    
    func setNewDate(date: Date) {
        try! Database.manager.data.write {
            self.textValue.created = date
            self.textValue.edited = Date()
        }
        
        self.tableNode.reloadSections(IndexSet(integer: 2), with: .automatic)
        self.updateWeatherInformation()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print("save went wrong - \(error!.localizedDescription)")
            return
        }
        
        print("Save image to camera roll ok")
    }
    // MARK: - Keyboard actions
    @objc func keyboardWillShow(sender: Notification) {
        let height = (sender.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height
        
        self.tableNode.contentInset.bottom = height
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        self.tableNode.contentInset.bottom = 0.0
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.entryControllerStyle
            
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = style.barColor
            self.navigationController?.navigationBar.tintColor = style.barTint
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: style.barTint, NSAttributedStringKey.font: style.barTitleFont]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: style.barTint, NSAttributedStringKey.font: style.barLargeTitleFont]
            }
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
            // Backgrounds
            self.view.backgroundColor = style.background
            self.tableNode.backgroundColor = UIColor.clear
            
            self.tableNode.reloadData()
        })
    }
}