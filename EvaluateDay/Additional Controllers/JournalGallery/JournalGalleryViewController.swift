//
//  JournalGalleryViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class JournalGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var card: Card!
    var photos = [PhotoValue]()
    private let reuseIdentifier = "photoCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.Activity.Gallery.title
        
        // Set photos
        if let journal = self.card.data as? JournalCard {
            let entries = journal.values
            
            for entry in entries {
                let photoValues = entry.photos
                for photo in photoValues {
                    self.photos.append(photo)
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.updateCollectionViewLayout(size: size)
        super.viewWillTransition(to: size, with: coordinator)
//        print("Galery size: width - \(size.width), height - \(size.height)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
        self.updateCollectionViewLayout(size: self.view.frame.size)
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
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            }
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // Collection View
            self.collectionView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCell
        cell.photoView.image = self.photos[indexPath.row].image
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let controller = UIStoryboard(name: Storyboards.photo.rawValue, bundle: nil).instantiateInitialViewController() as! PhotoViewController
        controller.photoValue = self.photos[indexPath.row]
        self.present(controller, animated: true, completion: nil)
    }

    // MARK: - Private actions
    private func updateCollectionViewLayout(size: CGSize) {
        //let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 5.0
        let numberOfItems = Int(size.width / 150.0)
        let itemWidth = (size.width - itemSpacing * (CGFloat(numberOfItems + 1))) / CGFloat(numberOfItems)
        let itemHeight = itemWidth / 1.5
        
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.collectionView!.setCollectionViewLayout(layout, animated: false)
    }
}
