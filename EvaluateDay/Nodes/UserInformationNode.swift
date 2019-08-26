//
//  UserInformationNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class UserInformationNode: ASCellNode {
    // MARK: - UI
    var editButton = ASButtonNode()
    var userPhoto: ASImageNode!
    var userName: ASTextNode!
    var userEmail: ASTextNode!
    var userBio: ASTextNode!
    var userWeb: ASTextNode!
    var emptyProfileDescription = ASTextNode()
    var firstSeparator: ASDisplayNode!
    var secondSeparator: ASDisplayNode!
    
    // MARK: - Variables
    var editMode = false
    var nodeDidLoad: (() -> Void)?
    
    // MARK: - Init
    init(photo: UIImage?, name: String?, email: String?, bio: String?, web: String?, isEdit: Bool) {
        super.init()
        
        self.emptyProfileDescription.attributedText = NSAttributedString(string: Localizations.Activity.User.Description.empty, attributes: [NSAttributedString.Key.foregroundColor: UIColor.main, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2)])
        
        self.editMode = isEdit
        
        if self.editMode || photo != nil {
            self.userPhoto = ASImageNode()
            self.userPhoto.image = Images.Media.userAvatar.image
            if photo != nil {
                self.userPhoto.image = photo
            }
        }
        
        if self.editMode {
            self.userPhoto.isAccessibilityElement = true
            self.userPhoto.accessibilityTraits = UIAccessibilityTraits.button
            self.userPhoto.accessibilityLabel = Localizations.Accessibility.Activity.PersonalInformation.image
        }
        
        var editString = Localizations.General.edit
        var accessibilityEditLabel = Localizations.Accessibility.Activity.PersonalInformation.edit
        if editMode {
            editString = Localizations.General.done
            accessibilityEditLabel = Localizations.Accessibility.Activity.PersonalInformation.save
        }
        let editAttr = NSAttributedString(string: editString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor: UIColor.main])
        let editHighlightedAttr = NSAttributedString(string: editString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedString.Key.foregroundColor: UIColor.text])
        self.editButton.setAttributedTitle(editAttr, for: .normal)
        self.editButton.setAttributedTitle(editHighlightedAttr, for: .highlighted)
        self.editButton.accessibilityLabel = accessibilityEditLabel
        
        var nameAttr = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedString.Key.foregroundColor: UIColor.main]
        var emailAttr = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main]
        var bioAttr = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main]
        var webAttr = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main]
        
        if !isEdit {
            if name != nil {
                nameAttr[NSAttributedString.Key.foregroundColor] = UIColor.text
                self.userName = ASTextNode()
                self.userName.attributedText = NSAttributedString(string: name!, attributes: nameAttr)
                self.userName.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.name
            }
            
            if email != nil {
                emailAttr[NSAttributedString.Key.foregroundColor] = UIColor.text
                self.userEmail = ASTextNode()
                self.userEmail.attributedText = NSAttributedString(string: email!, attributes: emailAttr)
                self.userEmail.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.email
            }
            
            if bio != nil {
                bioAttr[NSAttributedString.Key.foregroundColor] = UIColor.text
                self.userBio = ASTextNode()
                self.userBio.attributedText = NSAttributedString(string: bio!, attributes: bioAttr)
                self.userBio.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.bio
            }
            if web != nil {
                webAttr[NSAttributedString.Key.foregroundColor] = UIColor.text
                self.userWeb = ASTextNode()
                self.userWeb.attributedText = NSAttributedString(string: web!, attributes: webAttr)
                self.userWeb.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.site
            }
        } else {
            self.userName = ASTextNode()
            self.userEmail = ASTextNode()
            self.userName.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.name
            self.userEmail.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.email
            if name != nil {
                self.userName.attributedText = NSAttributedString(string: name!, attributes: nameAttr)
            } else {
                self.userName.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.name, attributes: nameAttr)
            }
            
            if email != nil {
                self.userEmail.attributedText = NSAttributedString(string: email!, attributes: emailAttr)
            } else {
                self.userEmail.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.email, attributes: emailAttr)
            }
            
            self.userBio = ASTextNode()
            self.userWeb = ASTextNode()
            self.userBio.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.bio
            self.userWeb.accessibilityValue = Localizations.Accessibility.Activity.PersonalInformation.site
            
            if bio != nil {
                self.userBio.attributedText = NSAttributedString(string: bio!, attributes: bioAttr)
            } else {
                self.userBio.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.bio, attributes: bioAttr)
            }
            if web != nil {
                self.userWeb.attributedText = NSAttributedString(string: web!, attributes: webAttr)
            } else {
                self.userWeb.attributedText = NSAttributedString(string: Localizations.Activity.User.Placeholder.web, attributes: webAttr)
            }
        }
        
        if isEdit || self.userBio != nil {
            self.secondSeparator = ASDisplayNode()
            self.secondSeparator.backgroundColor = UIColor.main
            
            self.firstSeparator = ASDisplayNode()
            self.firstSeparator.backgroundColor = UIColor.main
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func didLoad() {
        super.didLoad()
        self.nodeDidLoad?()
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let editStack = ASStackLayoutSpec.vertical()
        editStack.alignItems = .end
        editStack.children = [self.editButton]
        
        let editStackInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 10.0)
        let editStackInset = ASInsetLayoutSpec(insets: editStackInsets, child: editStack)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [editStackInset]
        
        if self.userName != nil || self.userEmail != nil || self.userWeb != nil || self.userPhoto != nil {
            
            let photoAndText = ASStackLayoutSpec.horizontal()
            photoAndText.spacing = 20.0
            photoAndText.children = []
            
            if self.userPhoto != nil {
                self.userPhoto.style.preferredSize = CGSize(width: 100.0, height: 100.0)
                self.userPhoto.cornerRadius = 10
                
                photoAndText.children?.append(self.userPhoto)
            }
            
            let nameAndEmail = ASStackLayoutSpec.vertical()
            nameAndEmail.spacing = 10.0
            nameAndEmail.style.flexShrink = 1.0
            nameAndEmail.children = []
            if self.userName != nil {
                self.userName.style.flexShrink = 1.0
                nameAndEmail.children?.append(self.userName)
            }
            if self.userEmail != nil {
                self.userEmail.style.flexShrink = 1.0
                nameAndEmail.children?.append(self.userEmail)
            }
            
            if self.userWeb != nil {
                nameAndEmail.children?.append(self.userWeb)
            }
            
            photoAndText.children?.append(nameAndEmail)
            
            let photoAndTextInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            let photoAndTextInset = ASInsetLayoutSpec(insets: photoAndTextInsets, child: photoAndText)
            
            cell.children?.append(photoAndTextInset)
        } else {
            let descriptionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            let descriptionInset = ASInsetLayoutSpec(insets: descriptionInsets, child: self.emptyProfileDescription)
            
            cell.children?.append(descriptionInset)
        }
        
        if self.firstSeparator != nil {
            self.firstSeparator.style.preferredSize = CGSize(width: 250.0, height: 0.2)
            cell.children?.append(self.firstSeparator)
        }
        
        if self.userBio != nil {
            let bioStack = ASStackLayoutSpec.vertical()
            bioStack.spacing = 10.0
            bioStack.children = []
            if self.userBio != nil {
                bioStack.children?.append(self.userBio)
            }
            
            let bioStackInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            let bioStackInset = ASInsetLayoutSpec(insets: bioStackInsets, child: bioStack)
            
            cell.children?.append(bioStackInset)
        }
        
        if self.secondSeparator != nil {
            self.secondSeparator.style.preferredSize = CGSize(width: 250.0, height: 0.2)
            let secondSeparateStack = ASStackLayoutSpec.vertical()
            secondSeparateStack.alignItems = .end
            secondSeparateStack.children = [self.secondSeparator]
            cell.children?.append(secondSeparateStack)
        }
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 30.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
