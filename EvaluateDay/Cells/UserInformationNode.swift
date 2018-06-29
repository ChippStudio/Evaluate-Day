//
//  UserInformationNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol UserInformationNodeStyle {
    var userInformationEditColor: UIColor { get }
    var userInformationEditHighlightedColor: UIColor { get }
    var userInformationEditFont: UIFont { get }
    var userInfomationColor: UIColor { get }
    var userInformationFont: UIFont { get }
    var userInformationPlaceholderColor: UIColor { get }
    var userInformationFacebookButtonFont: UIFont { get }
    var userInformationFacebookButtonColor: UIColor { get }
    var userInformationFacebookButtonCoverColor: UIColor { get }
    var userInformationFacebookButtonHighlightedColor: UIColor { get }
    var userInformationFacebookDisclaimerFont: UIFont { get }
    var userInformationFacebookDisclaimerColor: UIColor { get }
}

class UserInformationNode: ASCellNode {
    // MARK: - UI
    var editButton = ASButtonNode()
    var userPhoto = ASImageNode()
    var userName = ASTextNode()
    var userEmail = ASTextNode()
    var userBio: ASTextNode!
    var userWeb: ASTextNode!
    var facebookButton: ASButtonNode!
    var facebookCover: ASDisplayNode!
    var facebookDisclaimer: ASTextNode!
    
    // MARK: - Variables
    var editMode = false
    var nodeDidLoad: (() -> Void)?
    
    // MARK: - Init
    init(photo: UIImage?, name: String?, email: String?, bio: String?, web: String?, isEdit: Bool, style: UserInformationNodeStyle) {
        super.init()
        
        self.editMode = isEdit
        
        self.userPhoto.image = #imageLiteral(resourceName: "user")
        if photo != nil {
            self.userPhoto.image = photo
        } else {
            self.userPhoto.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.userInfomationColor)
        }
        
        var editString = Localizations.general.edit
        if editMode {
            editString = Localizations.general.done
        }
        let editAttr = NSAttributedString(string: editString, attributes: [NSAttributedStringKey.font: style.userInformationEditFont, NSAttributedStringKey.foregroundColor: style.userInformationEditColor])
        let editHighlightedAttr = NSAttributedString(string: editString, attributes: [NSAttributedStringKey.font: style.userInformationEditFont, NSAttributedStringKey.foregroundColor: style.userInformationEditHighlightedColor])
        self.editButton.setAttributedTitle(editAttr, for: .normal)
        self.editButton.setAttributedTitle(editHighlightedAttr, for: .highlighted)
        
        var nameAttr = [NSAttributedStringKey.font: style.userInformationFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        var emailAttr = [NSAttributedStringKey.font: style.userInformationFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        var bioAttr = [NSAttributedStringKey.font: style.userInformationFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        var webAttr = [NSAttributedStringKey.font: style.userInformationFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        
        if !isEdit {
            if name != nil {
                nameAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationColor
                self.userName.attributedText = NSAttributedString(string: name!, attributes: nameAttr)
            } else {
                self.userName.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.name, attributes: nameAttr)
            }
            
            if email != nil {
                emailAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationColor
                self.userEmail.attributedText = NSAttributedString(string: email!, attributes: emailAttr)
            } else {
                self.userEmail.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.email, attributes: emailAttr)
            }
            if bio != nil {
                bioAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationColor
                self.userBio = ASTextNode()
                self.userBio.attributedText = NSAttributedString(string: bio!, attributes: bioAttr)
            }
            if web != nil {
                webAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationColor
                self.userWeb = ASTextNode()
                self.userWeb.attributedText = NSAttributedString(string: web!, attributes: webAttr)
            }
        } else {
            if name != nil {
                self.userName.attributedText = NSAttributedString(string: name!, attributes: nameAttr)
            } else {
                self.userName.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.name, attributes: nameAttr)
            }
            
            if email != nil {
                self.userEmail.attributedText = NSAttributedString(string: email!, attributes: emailAttr)
            } else {
                self.userEmail.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.email, attributes: emailAttr)
            }
            
            self.userBio = ASTextNode()
            self.userWeb = ASTextNode()
            
            if bio != nil {
                self.userBio.attributedText = NSAttributedString(string: bio!, attributes: bioAttr)
            } else {
                self.userBio.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.bio, attributes: bioAttr)
            }
            if web != nil {
                self.userWeb.attributedText = NSAttributedString(string: web!, attributes: webAttr)
            } else {
                self.userWeb.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.web, attributes: webAttr)
            }
        }
        
        if isEdit || email == nil || name == nil {
            self.facebookCover = ASDisplayNode()
            self.facebookButton = ASButtonNode()
            self.facebookDisclaimer = ASTextNode()
            
            self.facebookCover.backgroundColor = style.userInformationFacebookButtonCoverColor
            self.facebookCover.cornerRadius = 5.0
            
            var facebookAttr = [NSAttributedStringKey.foregroundColor: style.userInformationFacebookButtonColor, NSAttributedStringKey.font: style.userInformationFacebookButtonFont]
            let facebookTitle = NSAttributedString(string: Localizations.activity.user.facebook.action, attributes: facebookAttr)
            facebookAttr[NSAttributedStringKey.foregroundColor] = style.userInformationFacebookButtonHighlightedColor
            let facebookHighlightedTitle = NSAttributedString(string: Localizations.activity.user.facebook.action, attributes: facebookAttr)
            self.facebookButton.setAttributedTitle(facebookTitle, for: .normal)
            self.facebookButton.setAttributedTitle(facebookHighlightedTitle, for: .highlighted)
            
            self.facebookDisclaimer.attributedText = NSAttributedString(string: Localizations.activity.user.facebook.disclaimer, attributes: [NSAttributedStringKey.foregroundColor: style.userInformationFacebookDisclaimerColor, NSAttributedStringKey.font: style.userInformationFacebookDisclaimerFont])
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
        
        self.userName.style.flexShrink = 1.0
        self.userEmail.style.flexShrink = 1.0
        
        let nameAndEmail = ASStackLayoutSpec.vertical()
        nameAndEmail.spacing = 5.0
        nameAndEmail.style.flexShrink = 1.0
        nameAndEmail.children = [self.userName, self.userEmail]
        
        self.userPhoto.style.preferredSize = CGSize(width: 80.0, height: 80.0)
        self.userPhoto.cornerRadius = 40.0
        
        let photoAndText = ASStackLayoutSpec.horizontal()
        photoAndText.spacing = 20.0
        photoAndText.alignItems = .center
        photoAndText.children = [self.userPhoto, nameAndEmail]
        
        let information = ASStackLayoutSpec.vertical()
        information.spacing = 5.0
        information.children = [editStack, photoAndText]
        if self.userBio != nil {
            self.userBio.style.flexShrink = 1.0
            information.children!.append(self.userBio)
        }
        if self.userWeb != nil {
            self.userWeb.style.flexShrink = 1.0
            information.children!.append(self.userWeb)
        }
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [information]
        
        if self.facebookButton != nil {
            let fbbInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
            let fbbInset = ASInsetLayoutSpec(insets: fbbInsets, child: self.facebookButton)
            
            let fbb = ASBackgroundLayoutSpec(child: fbbInset, background: self.facebookCover)
            
            let disclaimerInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
            let disclaimerInset = ASInsetLayoutSpec(insets: disclaimerInsets, child: self.facebookDisclaimer)
            
            let fullFacebook = ASStackLayoutSpec.vertical()
            fullFacebook.children = [fbb, disclaimerInset]
            
            cell.children!.append(fullFacebook)
        }
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
