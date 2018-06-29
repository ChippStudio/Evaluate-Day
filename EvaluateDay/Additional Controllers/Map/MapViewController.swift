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
    @IBOutlet weak var closeButtonCover: UIVisualEffectView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var baseView: UIVisualEffectView!
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var card: Card!
    
    private var annotations = [MapAnnotation]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        // TableNode
        self.tableNode = ASTableNode(style: .plain)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.backgroundColor = UIColor.clear
        self.baseView.contentView.addSubnode(self.tableNode)
        
        self.baseView.alpha = 0.0
        
        // Close button
        self.closeButtonCover.layer.cornerRadius = 25.0
        self.closeButtonCover.clipsToBounds = true
        self.closeButton.setImage(#imageLiteral(resourceName: "close").resizedImage(newSize: CGSize(width: 20.0, height: 20.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        if self.card == nil {
            return
        }
        
        if self.navigationController != nil {
            
            self.navigationItem.title = Localizations.analytics.journal.near
            
            self.closeButton.alpha = 0.0
            self.closeButtonCover.alpha = 0.0
            self.closeButton.isEnabled = false
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
        self.observable()
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
                let node = CheckInDataEvaluateNode(street: street, otherAddress: otherAddress, coordinates: coordinates, style: Themes.manager.evaluateStyle)
                node.selectionStyle = .none
                return node
            }
        }
        
        if self.card.type == .journal {
            let value = self.annotations[indexPath.row].locationValue
            if let entry = Database.manager.data.objects(TextValue.self).filter("id=%@", value.owner).first {
                let text = entry.text
                var metadata = [String]()
                metadata.append(DateFormatter.localizedString(from: entry.created, dateStyle: .short, timeStyle: .short))
                if let loc = entry.location {
                    metadata.append(loc.streetString)
                }
                var photo: UIImage?
                if let p = entry.photos.first {
                    photo = p.image
                }
                
                return {
                    let node = JournalEntryNode(text: text, metadata: metadata, photo: photo, style: Themes.manager.evaluateStyle)
                    node.leftOffset = 10.0
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
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.mapControllerStyle
            
            self.closeButtonCover.effect = UIBlurEffect(style: style.blurStyle)
            self.baseView.effect = UIBlurEffect(style: style.blurStyle)
            
            self.closeButton.imageView?.tintColor = style.tintColor
        })
    }
}
