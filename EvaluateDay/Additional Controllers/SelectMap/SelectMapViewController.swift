//
//  SelectMapViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift
import SnapKit

@objc protocol SelectMapViewControllerDelegate {
    func selectLocation(controller: SelectMapViewController, locationValue value: LocationValue?)
    func deleteLocation(controller: SelectMapViewController, locationValue value: LocationValue?)
}

class SelectMapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate {

    // MARK: - UI
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var closeButtonCover: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var currentLocationButtonCover: UIView!
    
    var searchBar: UISearchBar = UISearchBar()
    
    // MARK: - Variables
    var locations: Results<LocationValue>!
    var isSearchMode = false
    var searchResult = [MKMapItem]()
    var selectedLocation: LocationValue? {
        didSet {
            self.generateInformationView()
            if self.selectedAnnotation != nil {
                self.mapView.removeAnnotation(self.selectedAnnotation!)
            }
            if self.selectedLocation != nil {
                if self.selectedLocation!.realm != nil {
                    let region = MKCoordinateRegionMakeWithDistance(self.selectedLocation!.location.coordinate, 1000, 1000)
                    self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
                    let annotation = MapAnnotation(locationValue: self.selectedLocation!)
                    self.mapView.addAnnotation(annotation)
                } else {
                    self.selectedAnnotation = MapAnnotation(locationValue: self.selectedLocation!)
                    self.mapView.addAnnotation(self.selectedAnnotation!)
                }
            }
        }
    }
    
    weak var delegate: SelectMapViewControllerDelegate?
    
    private var topConstaraint: Constraint?
    private var selectedAnnotation: MapAnnotation?
    private var tableView: UITableView!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseView.layer.masksToBounds = true
        self.baseView.layer.cornerRadius = 10.0
        
        // Close button
        self.closeButtonCover.layer.cornerRadius = 25.0
        self.closeButtonCover.clipsToBounds = true
        self.closeButton.setImage(#imageLiteral(resourceName: "closeCircle").resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.currentLocationButtonCover.layer.cornerRadius = 25.0
        self.currentLocationButtonCover.clipsToBounds = true
        self.currentLocationButton.setImage(#imageLiteral(resourceName: "currentLocation").resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        // set gestures
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.mapViewLongGestureAction(_:)))
        longGesture.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longGesture)
        
        // Current Location
        _ = Permissions.defaults.currentLocation.asObservable().subscribe(onNext: { (location) in
            if location != nil {
                let region = MKCoordinateRegionMakeWithDistance(location!.coordinate, 1000, 1000)
                self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.observable()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let item = self.searchResult[indexPath.row]
        let style = Themes.manager.mapControllerStyle
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.text = item.name
        cell.textLabel?.font = style.checkInDataStreetFont
        cell.textLabel?.textColor = style.tintColor
        cell.textLabel?.numberOfLines = 0
        
        cell.detailTextLabel?.text = "\(item.placemark.coordinate.latitude), \(item.placemark.coordinate.longitude)"
        cell.detailTextLabel?.font = style.checkInDataOtherAddressFont
        cell.detailTextLabel?.textColor = style.tintColor
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.searchResult[indexPath.row]
        
        guard let location = item.placemark.location else {
            return
        }
        
        let value = LocationValue()
        value.location = location
        value.street = item.placemark.name
        value.city = item.placemark.locality
        value.state = item.placemark.administrativeArea
        value.country = item.placemark.country
        
        self.searchBar.resignFirstResponder()
        self.isSearchMode = false
        self.selectedLocation = value
        let region = MKCoordinateRegionMakeWithDistance(value.location.coordinate, 1000, 1000)
        self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !self.isSearchMode {
            self.isSearchMode = true
            self.generateInformationView()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchMode = false
        self.generateInformationView()
    }
    
    private var timer: Timer?
    private var searchRequest: MKLocalSearch?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchRequest != nil {
            self.searchRequest!.cancel()
        }
        if self.timer != nil {
            timer!.invalidate()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (_) in
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchText
            
            self.searchRequest = MKLocalSearch(request: request)
            self.searchRequest!.start(completionHandler: { (responce, _) in
                if responce == nil {
                    self.searchResult.removeAll()
                } else {
                    self.searchResult = responce!.mapItems
                }
                
                self.tableView.reloadData()
            })
        })
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if #available(iOS 11.0, *) {
            if let cluster = annotation as? MKClusterAnnotation {
                let view = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: "p")
                view.subtitleVisibility = .hidden
                view.titleVisibility = .hidden
                return view
            }
        }
        
        if annotation is MKUserLocation {
            return nil
        } else {
            if #available(iOS 11.0, *) {
                let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "d")
                view.clusteringIdentifier = "pd"
                return view
            } else {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "f")
                view.image = #imageLiteral(resourceName: "locationMark").resizedImage(newSize: CGSize(width: 30.0, height: 30.0))
                return view
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MapAnnotation else {
            return
        }
        
        self.selectedLocation = annotation.locationValue
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
        guard let location = Permissions.defaults.currentLocation.value else {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
    }
    
    @objc func selectLocationButtonAction(sender: UIButton) {
        self.delegate?.selectLocation(controller: self, locationValue: self.selectedLocation)
    }
    
    @objc func deleteLocationValueAction(sender: UIButton) {
        self.delegate?.deleteLocation(controller: self, locationValue: self.selectedLocation)
    }
    
    // MARK: - Generate view
    func generateInformationView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.baseView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        }) { (_) in
            for v in self.baseView.subviews {
                v.removeFromSuperview()
            }
            
            if self.topConstaraint != nil {
                self.topConstaraint!.deactivate()
            }
            
            // Set views
            let searchView = self.searchView()
            self.baseView.addSubview(searchView)
            searchView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(10.0)
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            })
            
            if self.isSearchMode {
                let table = self.searchItemsView()
                self.baseView.addSubview(table)
                table.snp.makeConstraints({ (make) in
                    make.top.equalTo(searchView.snp.bottom).offset(5.0)
                    make.trailing.equalToSuperview()
                    make.leading.equalToSuperview()
                    if #available(iOS 11.0, *) {
                        make.bottom.equalTo(self.baseView.safeAreaLayoutGuide).offset(-10.0)
                    } else {
                        make.bottom.equalToSuperview().offset(-10.0)
                    }
                })
                self.baseView.snp.makeConstraints({ (make) in
                    self.topConstaraint = make.top.equalTo(self.closeButtonCover.snp.bottom).offset(20.0).constraint
                })
            } else if self.selectedLocation != nil {
                let locationView = self.selectPlaceInformation()
                self.baseView.addSubview(locationView)
                locationView.snp.makeConstraints({ (make) in
                    make.top.equalTo(searchView.snp.bottom).offset(5.0)
                    make.trailing.equalToSuperview()
                    make.leading.equalToSuperview()
                    if #available(iOS 11.0, *) {
                        make.bottom.equalTo(self.baseView.safeAreaLayoutGuide).offset(-10.0)
                    } else {
                        make.bottom.equalToSuperview().offset(-10.0)
                    }
                })
            } else {
                searchView.snp.makeConstraints({ (make) in
                    if #available(iOS 11.0, *) {
                        make.bottom.equalTo(self.baseView.safeAreaLayoutGuide).offset(-10.0)
                    } else {
                        make.bottom.equalToSuperview().offset(-10.0)
                    }
                })
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.baseView.transform = CGAffineTransform.identity
            }, completion: { (_) in
                
            })
        }
    }
    
    // MARK: - Private views generator
    private func searchView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = Themes.manager.mapControllerStyle.tintColor
        searchBar.delegate = self
        if self.isSearchMode {
            searchBar.becomeFirstResponder()
            searchBar.showsCancelButton = true
        } else {
            searchBar.showsCancelButton = false
        }
        view.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        return view
    }
    
    private func selectPlaceInformation() -> UIView {
        
        guard let value = self.selectedLocation else {
            return UIView()
        }
        let style = Themes.manager.mapControllerStyle
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let streetLabel = UILabel()
        streetLabel.text = value.streetString
        streetLabel.textColor = style.tintColor
        streetLabel.font = style.checkInDataStreetFont
        streetLabel.numberOfLines = 0
        view.addSubview(streetLabel)
        streetLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
        }
        
        let otherAddressLabel = UILabel()
        otherAddressLabel.text = value.otherAddressString
        otherAddressLabel.textColor = style.tintColor
        otherAddressLabel.font = style.checkInDataOtherAddressFont
        otherAddressLabel.numberOfLines = 0
        view.addSubview(otherAddressLabel)
        otherAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(streetLabel.snp.bottom)
            make.leading.equalToSuperview().offset(30.0)
            make.trailing.equalToSuperview().offset(-10.0)
        }
        
        let coordinateLabel = UILabel()
        coordinateLabel.text = value.coordinatesString
        coordinateLabel.textColor = style.tintColor
        coordinateLabel.textAlignment = .right
        coordinateLabel.font = style.checkInDataCoordinatesFont
        coordinateLabel.numberOfLines = 0
        view.addSubview(coordinateLabel)
        coordinateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(otherAddressLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
        }
        
        let button = UIButton()
        button.addTarget(self, action: #selector(self.selectLocationButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(streetLabel)
            make.bottom.equalTo(coordinateLabel)
        }
        
        if value.realm != nil {
            let deleteButton = UIButton()
            deleteButton.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysTemplate), for: .normal)
            deleteButton.setTitle(" " + Localizations.general.delete, for: .normal)
            deleteButton.imageView?.contentMode = .scaleAspectFit
            deleteButton.imageView?.tintColor = style.deleteTintColor
            deleteButton.setTitleColor(style.deleteTintColor, for: .normal)
            deleteButton.setTitleColor(style.tintColor, for: .highlighted)
            deleteButton.titleLabel?.font = style.checkInDataDeleteFont
            deleteButton.addTarget(self, action: #selector(self.deleteLocationValueAction(sender:)), for: .touchUpInside)
            view.addSubview(deleteButton)
            deleteButton.snp.makeConstraints({ (make) in
                make.height.equalTo(35.0)
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
                make.top.equalTo(coordinateLabel.snp.bottom).offset(20.0)
                make.top.greaterThanOrEqualTo(button.snp.bottom).offset(20.0)
                make.bottom.equalToSuperview().offset(-10.0)
            })
        } else {
            button.snp.makeConstraints({ (make) in
                make.bottom.lessThanOrEqualToSuperview().offset(-10.0)
            })
            coordinateLabel.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview().offset(-10.0)
            })
        }
        
        return view
    }
    
    private func searchItemsView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        return view
    }
    
    @objc func mapViewLongGestureAction(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let touch = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(touch, toCoordinateFrom: self.mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let value = LocationValue()
            value.location = location
            value.locationInformation(completion: { (street, city, state, country) in
                value.street = street
                value.city = city
                value.state = state
                value.country = country
                
                self.selectedLocation = value
            })
        default: ()
        }
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.mapControllerStyle
            
            self.closeButtonCover.backgroundColor = style.background
            self.currentLocationButtonCover.backgroundColor = style.background
            self.baseView.backgroundColor = style.background
            
            self.closeButton.imageView?.tintColor = style.tintColor
            self.currentLocationButton.imageView?.tintColor = style.tintColor
            
            self.searchBar.tintColor = style.tintColor
            self.searchBar.textColor = style.tintColor
            
            self.generateInformationView()
        })
    }
}
