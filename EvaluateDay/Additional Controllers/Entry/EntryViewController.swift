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

class EntryViewController: UIViewController, SelectMapViewControllerDelegate, TimeBottomViewControllerDelegate, ASEditableTextNodeDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, ASPagerDelegate, ASPagerDataSource {
    
    // MARK: - UI
    var pageNode: ASPagerNode!
    var deleteButton: UIBarButtonItem!
    var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageCover: UIView!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Variables
    var textValue: TextValue!
    var card: Card!
    
    var new: Bool = false
    
    private let numbersOfPages = 4
    private var lock = false
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        // Delete button
        self.deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.deleteAction(sender:)))
        self.deleteButton.accessibilityLabel = Localizations.General.delete
        self.navigationItem.rightBarButtonItems = [self.deleteButton]
        
        // Close button
        if self.navigationController?.viewControllers.first is EntryViewController {
            self.closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(closeButtonAction(sender:)))
            self.navigationItem.leftBarButtonItem = closeButton
        }
        
        // Lock
        if self.textValue.created.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro {
            self.lock = true
        }
        
        self.deleteButton.isEnabled = !self.lock
        self.textView.isEditable = !self.lock
        
        self.textView.text = textValue.text
        self.textView.contentInset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 100.0, right: 0.0)
        
        if self.textValue.location == nil {
            self.quickCheckIn(sender: ASButtonNode())
        }
        
        self.pageNode = ASPagerNode()
        self.pageNode.setDelegate(self)
        self.pageNode.setDataSource(self)
        self.pageCover.addSubnode(self.pageNode)
        
        self.pageControl.numberOfPages = self.numbersOfPages
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(sender:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        sendEvent(.openEntry, withProperties: ["new": self.new])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageNode.frame = self.pageCover.bounds
        if self.pageNode != nil {
            self.pageNode.reloadData(completion: nil)
        }
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            }
            
            self.textView.textColor = UIColor.text
            self.pageCover.backgroundColor = UIColor.background
            self.pageNode.backgroundColor = UIColor.background
            self.pageControl.pageIndicatorTintColor = UIColor.textTint
            self.pageControl.currentPageIndicatorTintColor = UIColor.main
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            self.textView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - ASPagerDataSource
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return self.numbersOfPages
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        switch index {
        case 0:
            var images = [UIImage]()
            for im in self.textValue.photos {
                images.append(im.image)
            }
            
            return {
                let node = ImagesNode(images: images)
                node.didSelectDeletePhotoAction = { (index) in
                    self.deletePhotoAction(index: index)
                }
                node.didSelectPhotoAction = { (index) in
                    self.photoAction()
                }
                node.didSelectCameraAction = { (index) in
                    self.cameraAction()
                }
                node.didSelectImage = { (index) in
                    let controller = UIStoryboard(name: Storyboards.photo.rawValue, bundle: nil).instantiateInitialViewController() as! PhotoViewController
                    controller.photoValue = self.textValue.photos[index]
                    self.present(controller, animated: true, completion: nil)
                }
                return node
            }
        case 2:
            var street = ""
            var otherAddress = ""
            var coordinates = ""
            
            if let loc = self.textValue.location {
                street = loc.streetString
                otherAddress = loc.otherAddressString
                coordinates = loc.coordinatesString
            } else {
                otherAddress = Localizations.Evaluate.Checkin.Permission.description
            }
            return {
                let node = LocationNode(street: street, otherAddress: otherAddress, coordinates: coordinates)
                node.button.addTarget(self, action: #selector(self.openMap(sender:)), forControlEvents: .touchUpInside)
                return node
            }
        case 1:
            let date = self.textValue.created
            return {
                let node = DateNode(date: date)
                node.button.addTarget(self, action: #selector(self.timeAction(sender:)), forControlEvents: .touchUpInside)
                return node
            }
        case 3:
            var data = [String]()
            var text = Localizations.Evaluate.Weather.unknown
            var icon: UIImage? = Images.Weather.clearDay.image
            if let w = self.textValue.weather {
                icon = UIImage(named: w.icon)
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
                
                text = Localizations.Evaluate.Journal.Entry.weather(temperature, apparentTemperature, humidity, pressure, windSpeed, cc)
            }
            
            return {
                let node = WeatherNode(icon: icon, text: text, data: data)
                node.selectionStyle = .none
                return node
            }
        default:
            return {
                return ASCellNode()
            }
        }
    }
    
    // MARK: - ASPagerDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = self.pageNode.currentPageIndex
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
        
        self.pageNode.reloadData()
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
        
        self.pageNode.reloadData()
        
        guard let weather = self.textValue.weather else {
            return
        }
        
        try! Database.manager.data.write {
            weather.isDeleted = true
        }
        
        self.pageNode.reloadData()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            var mainAsset: PHAsset?
            if #available(iOS 11.0, *) {
                if let asset = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.phAsset)] as? PHAsset {
                    mainAsset = asset
                }
            } else {
                // Fallback on earlier versions
                if let assetURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.referenceURL)] as? String {
                    let url = URL(fileURLWithPath: assetURL)
                    if let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {
                        mainAsset = asset
                    }
                }
            }
            
            let photo = PhotoValue()
            photo.owner = self.textValue.id
            photo.image = image
            
            try! Database.manager.data.write {
                Database.manager.data.add(photo)
            }
            
            self.pageNode.reloadData()
            
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
                    if let currentLocation = Permissions.defaults.currentLocation {
                        if loc!.distance(from: currentLocation) < 500 {
                            return
                        }
                    }
                }
                
                var partTitle = ""
                var message = ""
                if date != nil {
                    partTitle = Localizations.Evaluate.Journal.Entry.Photo.date
                    message = DateFormatter.localizedString(from: date!, dateStyle: .medium, timeStyle: .short)
                }
                if partTitle != "" {
                    partTitle += " \(Localizations.General.and) "
                }
                if loc != nil {
                    partTitle += Localizations.Evaluate.Journal.Entry.Photo.location
                }
                
                let title = Localizations.Evaluate.Journal.Entry.Photo.question(partTitle)
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
                let dateAction = UIAlertAction(title: Localizations.Evaluate.Journal.Entry.Photo.date, style: .default, handler: { (_) in
                    
                    self.setNewDate(date: date!)
                })
                let locationAction = UIAlertAction(title: Localizations.Evaluate.Journal.Entry.Photo.location, style: .default, handler: { (_) in
                    self.setNewLocation(location: loc!)
                })
                let bothAction = UIAlertAction(title: Localizations.Evaluate.Journal.Entry.Photo.useBoth, style: .default, handler: { (_) in
                    
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
                
                if loc == nil {
                    self.present(alert, animated: true) {
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
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        try! Database.manager.data.write {
            self.textValue.text = textView.text
        }
    }
    
    // MARK: - Keyboard actions
    @objc func keyboardWillShow(sender: Notification) {
        let height = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height
        
        self.textView.contentInset.bottom = height
    }
    
    @objc func keyboardDidHide(sender: Notification) {
        
        self.textView.contentInset.bottom = 100
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
                    
//                    self.tableNode.reloadSections(IndexSet(integer: 3), with: .automatic)
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
            
            self.pageNode.reloadData()
            
        }
    }
    
    @objc func cameraAction() {
        if !Store.current.isPro && self.textValue.photos.count >= 1 {
            let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        if Permissions.defaults.cameraStatus != .authorized {
            Permissions.defaults.cameraAutorize(completion: {
                self.openPhotoPicker(withType: .camera)
            })
            return
        }
        self.openPhotoPicker(withType: .camera)
    }
    
    @objc func photoAction() {
        if !Store.current.isPro && self.textValue.photos.count >= 1 {
            let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        if Permissions.defaults.photoStatus != .authorized {
            Permissions.defaults.photoAutorize(completion: {
                self.openPhotoPicker(withType: .photoLibrary)
            })
            return
        }
        
        self.openPhotoPicker(withType: .photoLibrary)
    }
    
    @objc func timeAction(sender: ASButtonNode) {
        if self.lock {
            return
        }
        
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
    
    @objc func deletePhotoAction(index: Int) {
        let photo = self.textValue.photos[index]
        try! Database.manager.data.write {
            photo.isDeleted = true
        }
        
        self.pageNode.reloadData(completion: nil)
    }
    
    private func openPhotoPicker(withType type: UIImagePickerController.SourceType) {
        let photoController = UIImagePickerController()
        photoController.sourceType = type
        photoController.delegate = self
        self.present(photoController, animated: true, completion: nil)
    }
    
    @objc func allowLocation(sender: ASButtonNode) {
        Permissions.defaults.locationAuthorize {
            self.pageNode.reloadData()
        }
    }
    
    @objc func openMap(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.selectMap.rawValue, bundle: nil).instantiateInitialViewController() as! SelectMapViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func quickCheckIn(sender: ASButtonNode) {
        guard let currentLocation = Permissions.defaults.currentLocation else {
            return
        }
        
        self.setNewLocation(location: currentLocation)
    }
    
    @objc func deleteAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Localizations.General.sureQuestion, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: Localizations.General.delete, style: .destructive) { (_) in
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
            if self.navigationController?.viewControllers.first is EntryViewController {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alert.popoverPresentationController?.barButtonItem = self.deleteButton
            alert.popoverPresentationController?.sourceView = self.view
        }
        
        self.present(alert, animated: true) {
        }
    }
    
    @objc func closeButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
            
            self.pageNode.reloadData()
            self.updateWeatherInformation()
        }
    }
    
    func setNewDate(date: Date) {
        try! Database.manager.data.write {
            self.textValue.created = date
            self.textValue.edited = Date()
        }
        
        self.pageNode.reloadData(completion: nil)
        self.updateWeatherInformation()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print("save went wrong - \(error!.localizedDescription)")
            return
        }
        
        print("Save image to camera roll ok")
    }
}

// Helper function inserted by Swift 4.2 migrator
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
