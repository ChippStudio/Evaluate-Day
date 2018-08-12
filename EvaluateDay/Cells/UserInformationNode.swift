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
    var userInfomationNameColor: UIColor { get }
    var userInformationNameFont: UIFont { get }
    var userInfomationEmailColor: UIColor { get }
    var userInformationEmailFont: UIFont { get }
    var userInfomationBioColor: UIColor { get }
    var userInformationBioFont: UIFont { get }
    var userInfomationLinkColor: UIColor { get }
    var userInformationLinkFont: UIFont { get }
    var userInformationSeparatorColor: UIColor { get }
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
    var firstSeparator = ASDisplayNode()
    var userBio: ASTextNode!
    var userWeb: ASTextNode!
    var secondSeparator: ASDisplayNode!
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
            self.userPhoto.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.userInfomationNameColor)
        }
        
        var editString = Localizations.general.edit
        if editMode {
            editString = Localizations.general.done
        }
        let editAttr = NSAttributedString(string: editString, attributes: [NSAttributedStringKey.font: style.userInformationEditFont, NSAttributedStringKey.foregroundColor: style.userInformationEditColor])
        let editHighlightedAttr = NSAttributedString(string: editString, attributes: [NSAttributedStringKey.font: style.userInformationEditFont, NSAttributedStringKey.foregroundColor: style.userInformationEditHighlightedColor])
        self.editButton.setAttributedTitle(editAttr, for: .normal)
        self.editButton.setAttributedTitle(editHighlightedAttr, for: .highlighted)
        
        self.firstSeparator.backgroundColor = style.userInformationSeparatorColor
        
        var nameAttr = [NSAttributedStringKey.font: style.userInformationNameFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        var emailAttr = [NSAttributedStringKey.font: style.userInformationEmailFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        var bioAttr = [NSAttributedStringKey.font: style.userInformationBioFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        var webAttr = [NSAttributedStringKey.font: style.userInformationLinkFont, NSAttributedStringKey.foregroundColor: style.userInformationPlaceholderColor]
        
        if !isEdit {
            if name != nil {
                nameAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationNameColor
                self.userName.attributedText = NSAttributedString(string: name!, attributes: nameAttr)
            } else {
                self.userName.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.name, attributes: nameAttr)
            }
            
            if email != nil {
                emailAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationEmailColor
                self.userEmail.attributedText = NSAttributedString(string: email!, attributes: emailAttr)
            } else {
                self.userEmail.attributedText = NSAttributedString(string: Localizations.activity.user.placeholder.email, attributes: emailAttr)
            }
            if bio != nil {
                bioAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationBioColor
                self.userBio = ASTextNode()
                self.userBio.attributedText = NSAttributedString(string: bio!, attributes: bioAttr)
            }
            if web != nil {
                webAttr[NSAttributedStringKey.foregroundColor] = style.userInfomationLinkColor
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
        
        if isEdit || email != nil || name != nil {
            self.secondSeparator = ASDisplayNode()
            self.secondSeparator.backgroundColor = style.userInformationSeparatorColor
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
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            self.facebookDisclaimer.attributedText = NSAttributedString(string: Localizations.activity.user.facebook.disclaimer, attributes: [NSAttributedStringKey.foregroundColor: style.userInformationFacebookDisclaimerColor, NSAttributedStringKey.font: style.userInformationFacebookDisclaimerFont, NSAttributedStringKey.paragraphStyle: paragraphStyle])
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
        
        self.userName.style.flexShrink = 1.0
        self.userEmail.style.flexShrink = 1.0
        
        let nameAndEmail = ASStackLayoutSpec.vertical()
        nameAndEmail.spacing = 10.0
        nameAndEmail.style.flexShrink = 1.0
        nameAndEmail.alignItems = .center
        nameAndEmail.children = [self.userName, self.userEmail]
        
        self.userPhoto.style.preferredSize = CGSize(width: 130.0, height: 130.0)
        self.userPhoto.cornerRadius = 130/2
        
        let photoAndText = ASStackLayoutSpec.vertical()
        photoAndText.spacing = 20.0
        photoAndText.alignItems = .center
        photoAndText.children = [self.userPhoto, nameAndEmail]
        
        self.firstSeparator.style.preferredSize = CGSize(width: 250.0, height: 0.2)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [editStackInset, photoAndText, self.firstSeparator]
        
        if self.userBio != nil || self.userWeb != nil {
            let bioStack = ASStackLayoutSpec.vertical()
            bioStack.spacing = 10.0
            bioStack.children = []
            if self.userBio != nil {
                bioStack.children?.append(self.userBio)
            }
            if self.userWeb != nil {
                bioStack.children?.append(self.userWeb)
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
        
        if self.facebookButton != nil {
            self.facebookButton.style.preferredSize = CGSize(width: 290.0, height: 46)
            let fb = ASBackgroundLayoutSpec(child: self.facebookButton, background: self.facebookCover)
            
            let fbActionStack = ASStackLayoutSpec.vertical()
            fbActionStack.alignItems = .center
            fbActionStack.children = [fb, self.facebookDisclaimer]
            
            cell.children?.append(fbActionStack)
        }
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 30.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
