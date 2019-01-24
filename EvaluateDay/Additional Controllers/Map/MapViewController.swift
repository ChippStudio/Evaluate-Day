//
//  MapViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import MapKit
import AsyncDisplayKit

class MapViewController: UIViewController, MKMapViewDelegate, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var baseView: UIView!
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var card: Card!
    var navTitle = ""
    
    private var annotations = [MapAnnotation]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        // TableNode
        self.tableNode = ASTableNode(style: .plain)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        self.tableNode.backgroundColor = UIColor.clear
        self.baseView.addSubnode(self.tableNode)
        
        self.baseView.alpha = 0.0
        self.baseView.layer.masksToBounds = true
        self.baseView.layer.cornerRadius = 10.0
        
        if self.card == nil {
            return
        }
        
        if self.navigationController != nil {
            self.navigationItem.title = self.navTitle
        }
        
        if self.card.type == .checkIn {
            for v in (self.card.data as! CheckInCard).values {
                let annotation = MapAnnotation(locationValue: v)
                self.mapView.addAnnotation(annotation)
            }
        } else if self.card.type == .journal {
            for v in (self.card.data as! JournalCard).values {
                if v.location != nil {
                    let annotation = MapAnnotation(locationValue: v.location!)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableNode.frame = self.baseView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableNode.frame = self.baseView.bounds
        if self.navigationController != nil {
            if let tab = self.tabBarController {
                tab.setTabBarVisible(visible: false, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController != nil {
            if let tab = self.tabBarController {
                tab.setTabBarVisible(visible: true, animated: true)
            }
        }
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            
            self.baseView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.annotations.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        if self.card.type == .checkIn {
            let value = self.annotations[indexPath.row].locationValue
            let street = value.streetString
            let otherAddress = value.otherAddressString
            let coordinates = value.coordinatesString
            return {
                let node = CheckInDataEvaluateNode(street: street, otherAddress: otherAddress, coordinates: coordinates)
                node.selectionStyle = .none
                return node
            }
        }
        
        if self.card.type == .journal {
            let value = self.annotations[indexPath.row].locationValue
            if let entry = Database.manager.data.objects(TextValue.self).filter("id=%@", value.owner).first {
                let text = entry.text
                let date = entry.created
                var weatherImage: UIImage?
                var locationText = ""
                var weatherText = ""
                if let w = entry.weather {
                    weatherImage = UIImage(named: w.icon)
                    var temperature = "\(String(format: "%.0f", w.temperarure)) ℃"
                    if !Database.manager.application.settings.celsius {
                        temperature = "\(String(format: "%.0f", (w.temperarure * (9/5) + 32))) ℉"
                    }
                    weatherText = temperature
                }
                if let loc = entry.location {
                    locationText.append(loc.streetString)
                    locationText.append(", \(loc.cityString)")
                }
                var photos = [UIImage?]()
                for p in entry.photos {
                    photos.append(p.image)
                }
                if photos.isEmpty {
                    photos.append(nil)
                }
                
                return {
                    let node = JournalEntryNode(preview: text, images: photos, date: date, weatherImage: weatherImage, weatherText: weatherText, locationText: locationText)
                    return node
                }
            }
        }
        
        return {
            return ASCellNode()
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        if self.card.type == .journal {
            if let entry = Database.manager.data.objects(TextValue.self).filter("id=%@", self.annotations[indexPath.row].locationValue.owner).first {
                let controller = UIStoryboard(name: Storyboards.entry.rawValue, bundle: nil).instantiateInitialViewController() as! EntryViewController
                controller.card = self.card
                controller.textValue = entry
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
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
        if #available(iOS 11.0, *) {
            if let mkView = view as? MKMarkerAnnotationView {
                if mkView.annotation is MKUserLocation {
                    
                } else if let annotation = mkView.annotation as? MKClusterAnnotation {
                    for a in annotation.memberAnnotations {
                        if let an = a as? MapAnnotation {
                            self.annotations.append(an)
                        }
                    }
                } else {
                    if let an = view.annotation as? MapAnnotation {
                        self.annotations.append(an)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            if let an = view.annotation as? MapAnnotation {
                self.annotations.append(an)
            }
        }
        
        self.tableNode.reloadData()
        UIView.animate(withDuration: 0.2) {
            self.baseView.alpha = 1.0
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.annotations.removeAll()
        UIView.animate(withDuration: 0.2) {
            self.baseView.alpha = 0.0
        }
        self.tableNode.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
