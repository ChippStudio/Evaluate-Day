//
//  PhotoViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - UI
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeButtonCover: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoCoverView: UIView!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    private var imageView = UIImageView()
    
    // MARK: - Variables
    var photoValue: PhotoValue!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let style = Themes.manager.evaluateStyle
        
        self.view.backgroundColor = style.background
        self.closeButtonCover.backgroundColor = style.background
        self.closeButtonCover.layer.masksToBounds = true
        self.closeButtonCover.layer.cornerRadius = 25.0
        
        self.infoCoverView.backgroundColor = style.background
        self.infoCoverView.layer.masksToBounds = true
        self.infoCoverView.layer.cornerRadius = 10.0
        
        self.createdLabel.textColor = style.barTint
        self.createdLabel.font = style.imageInfoDateLabelFont
        self.createdLabel.text = Localizations.general.createDate + ": " + DateFormatter.localizedString(from: self.photoValue.created, dateStyle: .medium, timeStyle: .medium)
        
        if self.photoValue.latitude != 0.0 && self.photoValue.longitude != 0.0 {
            self.coordinatesLabel.textColor = style.barTint
            self.coordinatesLabel.font = style.imageInfoCoordinatesFont
            self.coordinatesLabel.text = "\(self.photoValue.latitude), \(self.photoValue.longitude)"
            
            let location = CLLocation(latitude: self.photoValue.latitude, longitude: self.photoValue.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (places, _) in
                if let place = places?.first {
                    self.placeLabel.textColor = style.barTint
                    self.placeLabel.font = style.imageInfoPlaceFont
                    var placeString = ""
                    if let name = place.name {
                         placeString += name
                    }
                    if let locality = place.locality {
                        placeString += ", " + locality
                    }
                    if let administrativeArea = place.administrativeArea {
                        placeString += ", " + administrativeArea
                    }
                    if let country = place.country {
                        placeString += ", " + country
                    }
                    self.placeLabel.text = placeString
                }
            }
        }
        
        self.closeButton.setImage(#imageLiteral(resourceName: "closeCircle").resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeButton.tintColor = style.barTint

        let image = self.photoValue.image
        self.imageView.image = image
        self.imageView.frame.size = image.size
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.delegate = self
        self.setZoomScale()
        
        self.scrollView.addSubview(self.imageView)
        
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(sender:))))
        UIView.animate(withDuration: 0.3) {
            self.closeButtonCover.alpha = 1.0
            self.infoCoverView.alpha = 1.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = self.view.frame.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        UIView.animate(withDuration: 0.3) {
            self.closeButtonCover.alpha = 0.0
            self.infoCoverView.alpha = 0.0
        }
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapGestureAction(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.closeButtonCover.alpha = 1.0
            self.infoCoverView.alpha = 1.0
        }
    }
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = self.view.frame.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = self.scrollView.minimumZoomScale
    }
}
