//
//  ActivityUserSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ActivityUserSection: ListSectionController, ASSectionController, TextViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variables
    var isEditMode = false
    private var node: UserInformationNode!
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        let user = Database.manager.application.user!
        var photo: UIImage? = nil
        if let av = user.avatar {
            photo = UIImage(data: av)
        }
        let name = user.name
        let email = user.email
        var bio = user.bio
        let web = user.web
        
        // Set place holders
        if bio == nil && name == nil && !self.isEditMode {
            bio = Localizations.Activity.User.Description.bio
        }
        return {
            self.node = UserInformationNode(photo: photo, name: name, email: email, bio: bio, web: web, isEdit: self.isEditMode)
            self.node.editButton.addTarget(self, action: #selector(self.editButtonAction(sender:)), forControlEvents: .touchUpInside)
            self.node.nodeDidLoad = { () in
                if self.isEditMode {
                    self.node.userName.view.isUserInteractionEnabled = true
                    self.node.userEmail.view.isUserInteractionEnabled = true
                    self.node.userBio.view.isUserInteractionEnabled = true
                    self.node.userWeb.view.isUserInteractionEnabled = true
                    self.node.userPhoto.view.isUserInteractionEnabled = true
                    
                    self.node.userName.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nameTapAction(sender:))))
                    self.node.userEmail.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.emailTapAction(sender:))))
                    self.node.userBio.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.bioTapAction(sender:))))
                    self.node.userWeb.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.webTapAction(sender:))))
                    self.node.userPhoto.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.photoTapAction(sender:))))
                }
            }
            return self.node
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
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
        
    }
    
    // MARK: - TextViewControllerDelegate
    func textTopController(controller: TextViewController, willCloseWith text: String, forProperty property: String) {
        switch property {
        case "name":
            var newText: String? = nil
            if !text.isEmpty {
                newText = text
            }
            try! Database.manager.app.write {
                Database.manager.application.user.name = newText
            }
        case "email":
            var newText: String? = nil
            if !text.isEmpty {
                newText = text
            }
            try! Database.manager.app.write {
                Database.manager.application.user.email = newText
            }
        case "bio":
            var newText: String? = nil
            if !text.isEmpty {
                newText = text
            }
            try! Database.manager.app.write {
                Database.manager.application.user.bio = newText
            }
        case "web":
            var newText: String? = nil
            if !text.isEmpty {
                newText = text
            }
            try! Database.manager.app.write {
                Database.manager.application.user.web = newText
            }
        default: ()
        }
        
        self.collectionContext?.performBatch(animated: true, updates: { (context) in
            context.reload(self)
        }, completion: { (_) in
            //
        })
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            var newRect: CGRect!
            
            let maxSize: CGFloat = 800.0
            if image.size.width > image.size.height {
                let scale = maxSize / image.size.width
                let newHeight = image.size.height * scale
                
                newRect = CGRect(x: 0.0, y: 0.0, width: maxSize, height: newHeight)
            } else {
                let scale = maxSize / image.size.height
                let newWidth = image.size.width * scale
                
                newRect = CGRect(x: 0.0, y: 0.0, width: newWidth, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(newRect.size)
            image.draw(in: newRect)
            if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                try! Database.manager.app.write {
                    Database.manager.application.user.avatar = newImage.pngData()
                }
            }
            UIGraphicsEndImageContext()
        }
        
        self.collectionContext?.performBatch(animated: true, updates: { (context) in
            context.reload(self)
        }, completion: { (_) in
            //
        })
    }
    
    // MARK: - Actions
    @objc func editButtonAction(sender: ASButtonNode) {
        self.isEditMode = !self.isEditMode
        self.collectionContext?.performBatch(animated: true, updates: { (context) in
            context.reload(self)
        }, completion: { (_) in
            //
        })
    }
    
    @objc func nameTapAction(sender: UITapGestureRecognizer) {
        let textController = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        textController.text = Database.manager.application.user.name
        textController.titleText = Localizations.Activity.User.Placeholder.name
        textController.property = "name"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func emailTapAction(sender: UITapGestureRecognizer) {
        let textController = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        textController.text = Database.manager.application.user.email
        textController.titleText = Localizations.Activity.User.Placeholder.email
        textController.property = "email"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func bioTapAction(sender: UITapGestureRecognizer) {
        let textController = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        textController.text = Database.manager.application.user.bio
        textController.titleText = Localizations.Activity.User.Placeholder.bio
        textController.property = "bio"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func webTapAction(sender: UITapGestureRecognizer) {
        let textController = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        textController.text = Database.manager.application.user.web
        textController.titleText = Localizations.Activity.User.Placeholder.web
        textController.property = "web"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func photoTapAction(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
        let takePhoto = UIAlertAction(title: Localizations.General.Photo.take, style: .default) { (_) in
            if Permissions.defaults.cameraStatus != .authorized {
                Permissions.defaults.cameraAutorize(completion: {
                    self.openPhotoPicker(withType: .camera)
                })
                return
            }
            self.openPhotoPicker(withType: .camera)
        }
        let selectPhoto = UIAlertAction(title: Localizations.General.Photo.select, style: .default) { (_) in
            if Permissions.defaults.photoStatus != .authorized {
                Permissions.defaults.photoAutorize(completion: {
                    self.openPhotoPicker(withType: .photoLibrary)
                })
                return
            }
            
            self.openPhotoPicker(withType: .photoLibrary)
        }
        
        alert.addAction(cancel)
        alert.addAction(takePhoto)
        alert.addAction(selectPhoto)
        
        if self.viewController!.view.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alert.popoverPresentationController?.sourceRect = node.userPhoto.frame
            alert.popoverPresentationController?.sourceView = node.view
        }
        
        self.viewController!.present(alert, animated: true) {
        }
    }
    
    // MARK: - Private
    private func openPhotoPicker(withType type: UIImagePickerController.SourceType) {
        let photoController = UIImagePickerController()
        photoController.sourceType = type
        photoController.delegate = self
        self.viewController!.present(photoController, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
