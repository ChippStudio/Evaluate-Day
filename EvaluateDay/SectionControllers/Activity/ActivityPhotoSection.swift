//
//  ActivityPhotoSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class ActivityPhotoSection: ListSectionController, ASSectionController {
    // MARK: - Variables
    var isFullGalery: Bool = false
    var photos: Results<PhotoValue>!
    
    // MARK: - Private variables
    private var isPro: Bool!
    private var realmNotification: NotificationToken!
    private var realmToken: NotificationToken!
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.isPro = Store.current.isPro
        
        self.photos = Database.manager.data.objects(PhotoValue.self).filter("isDeleted=%@", false).sorted(byKeyPath: "created", ascending: false)
        self.realmNotification = self.photos.observe { (_) in
            self.collectionContext?.performBatch(animated: true, updates: { (context) in
                print("RELOAD FROM PHOTOS")
                context.reload(self)
            }, completion: nil)
        }
        
        if let user = Database.manager.app.objects(User.self).first {
            self.realmToken = user.observe({ (_) in
                if self.isPro != Store.current.isPro {
                    self.isPro = Store.current.isPro
                    self.collectionContext?.performBatch(animated: true, updates: { (context) in
                        print("RELOAD FROM PRO PHOTOS")
                        context.reload(self)
                    }, completion: nil)
                }
            })
        }
    }
    // MARK: - Override
    override func numberOfItems() -> Int {
        if photos.count == 0 || !self.isPro {
            return 1
        }
        
        if self.isFullGalery {
            return photos.count + 1
        }
        
        if photos.count <= 6 {
            return photos.count + 1
        }
        
        return 8
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        var subtitle = ""
        if !self.isPro {
            subtitle = Localizations.Activity.Gallery.subtitle
        }
        if index == 0 {
            return {
                let node = TitleNode(title: Localizations.Activity.Gallery.title, subtitle: subtitle, image: #imageLiteral(resourceName: "gallery"))
                return node
            }
        }
        
        if !self.isFullGalery && index == 7 {
            return {
                let node = SettingsMoreNode(title: Localizations.Activity.Gallery.allPhotos, subtitle: nil, image: nil)
                OperationQueue.main.addOperation {
                    node.disclosureImage.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                }
                return node
            }
        }
        
        let photo = self.photos[index - 1].image
        return {
            let node = ActivityPhotoNode(image: photo)
            return node
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        var width = self.collectionContext!.containerSize.width/3
        if index == 7 && !self.isFullGalery {
            width = self.collectionContext!.containerSize.width
        }
        if index == 0 {
            width = self.collectionContext!.containerSize.width
        }
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if !self.isFullGalery && index == 7 {
            self.isFullGalery = true
            self.collectionContext?.performBatch(animated: true, updates: { (context) in
                context.reload(self)
            }, completion: nil)
            return
        }
        
        if index != 0 {
            let photo: PhotoValue = self.photos[index - 1]
            let controller = UIStoryboard(name: Storyboards.photo.rawValue, bundle: nil).instantiateInitialViewController() as! PhotoViewController
            controller.photoValue = photo
            self.viewController!.present(controller, animated: true, completion: nil)
        }
    }
}
