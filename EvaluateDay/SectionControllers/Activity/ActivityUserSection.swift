//
//  ActivityUserSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ActivityUserSection: ListSectionController, ASSectionController, TextTopViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variables
    var isEditMode = false
    var didFacebookPressed: ((_ section: ListSectionController) -> Void)?
    private var node: UserInformationNode!
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.activityControlerStyle
        
        let user = Database.manager.application.user!
        var photo: UIImage? = nil
        if let av = user.avatar {
            photo = UIImage(data: av)
        }
        let name = user.name
        let email = user.email
        let bio = user.bio
        let web = user.web
        return {
            self.node = UserInformationNode(photo: photo, name: name, email: email, bio: bio, web: web, isEdit: self.isEditMode, style: style)
            self.node.editButton.addTarget(self, action: #selector(self.editButtonAction(sender:)), forControlEvents: .touchUpInside)
            if self.node.facebookButton != nil {
                self.node.facebookButton.addTarget(self, action: #selector(self.facebookButtonAction(sender:)), forControlEvents: .touchUpInside)
            }
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
        
        let max = CGSize(width: width - collectionViewOffset, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width - collectionViewOffset, height: 0)
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
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            try! Database.manager.app.write {
                Database.manager.application.user.avatar = UIImagePNGRepresentation(image)
            }
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
    
    @objc func facebookButtonAction(sender: ASButtonNode) {
        self.didFacebookPressed?(self)
    }
    
    @objc func nameTapAction(sender: UITapGestureRecognizer) {
        let textController = TextTopViewController()
        textController.textView.text = Database.manager.application.user.name
        textController.title = Localizations.activity.user.placeholder.name
        textController.property = "name"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func emailTapAction(sender: UITapGestureRecognizer) {
        let textController = TextTopViewController()
        textController.textView.text = Database.manager.application.user.email
        textController.title = Localizations.activity.user.placeholder.email
        textController.property = "email"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func bioTapAction(sender: UITapGestureRecognizer) {
        let textController = TextTopViewController()
        textController.textView.text = Database.manager.application.user.bio
        textController.title = Localizations.activity.user.placeholder.bio
        textController.property = "bio"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func webTapAction(sender: UITapGestureRecognizer) {
        let textController = TextTopViewController()
        textController.textView.text = Database.manager.application.user.web
        textController.title = Localizations.activity.user.placeholder.web
        textController.property = "web"
        textController.delegate = self
        self.viewController?.present(textController, animated: true, completion: nil)
    }
    
    @objc func photoTapAction(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: Localizations.general.cancel, style: .cancel, handler: nil)
        let takePhoto = UIAlertAction(title: Localizations.general.photo.take, style: .default) { (_) in
            if Permissions.defaults.cameraStatus != .authorized {
                Permissions.defaults.cameraAutorize(completion: {
                    self.openPhotoPicker(withType: .camera)
                })
                return
            }
            self.openPhotoPicker(withType: .camera)
        }
        let selectPhoto = UIAlertAction(title: Localizations.general.photo.select, style: .default) { (_) in
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
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.viewController!.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        }
    }
    
    // MARK: - Private
    private func openPhotoPicker(withType type: UIImagePickerControllerSourceType) {
        let photoController = UIImagePickerController()
        photoController.sourceType = type
        photoController.delegate = self
        self.viewController!.present(photoController, animated: true, completion: nil)
    }
}
