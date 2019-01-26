//
//  ImagesNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ImagesNode: ASCellNode {
    
    // MARK: - UI
    private var imageNodes = [ImagePresenterNode]()
    private var newImageNode = [NewImagePresenterNode]()
    private var cover = ASDisplayNode()
    
    // MARK: - Variables
    var didSelectPhotoAction: ((_ index: Int) -> Void)?
    var didSelectCameraAction: ((_ index: Int) -> Void)?
    var didSelectDeletePhotoAction: ((_ index: Int) -> Void)?
    
    // MARK: - Init
    init(images: [UIImage]) {
        super.init()
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        for (i, image) in images.enumerated() {
            if i > 2 {
                break
            }
            
            let button = ASButtonNode()
            button.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.Entry.deletePhoto
            OperationQueue.main.addOperation {
                button.view.tag = i
            }
            button.setImage(Images.Media.close.image.resizedImage(newSize: CGSize(width: 21.0, height: 21.0)).withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
            button.addTarget(self, action: #selector(self.photoDeleteAction(sender:)), forControlEvents: .touchUpInside)
            
            let im = ImagePresenterNode(image: image, button: button)
            im.style.preferredSize = CGSize(width: 80.0, height: 80.0)
            
            self.imageNodes.append(im)
        }
        
        for i in self.imageNodes.count..<3 {
            let photoButton = ASButtonNode()
            let cameraButton = ASButtonNode()
            
            photoButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.Entry.openGalery
            cameraButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.Entry.openCamera
            OperationQueue.main.addOperation {
                photoButton.view.tag = i
                cameraButton.view.tag = i
            }
            photoButton.style.preferredSize = CGSize(width: 80.0, height: 40.0)
            photoButton.setImage(Images.Media.imagePlaceholder.image.resizedImage(newSize: CGSize(width: 20.0, height: 15.0)).withRenderingMode(.alwaysTemplate), for: .normal)
            photoButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
            photoButton.addTarget(self, action: #selector(self.photoAction(sender:)), forControlEvents: .touchUpInside)
            
            cameraButton.style.preferredSize = CGSize(width: 80.0, height: 40.0)
            cameraButton.setImage(Images.Media.camera.image.resizedImage(newSize: CGSize(width: 20.0, height: 17.0)).withRenderingMode(.alwaysTemplate), for: .normal)
            cameraButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
            cameraButton.addTarget(self, action: #selector(self.cameraAction(sender:)), forControlEvents: .touchUpInside)
            
            let new = NewImagePresenterNode(camera: cameraButton, photo: photoButton)
            new.backgroundColor = UIColor.clear
            new.style.preferredSize = CGSize(width: 80.0, height: 80.0)
            new.clipsToBounds = true
            new.cornerRadius = 40.0
            new.borderColor = UIColor.textTint.cgColor
            new.borderWidth = 1.0
            
            self.newImageNode.append(new)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let content = ASStackLayoutSpec.horizontal()
        content.justifyContent = .spaceAround
        content.alignItems = .center
        content.children = []
        for im in self.imageNodes {
            content.children?.append(im)
        }
        for im in self.newImageNode {
            content.children?.append(im)
        }
        
        let cell = ASBackgroundLayoutSpec(child: content, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func cameraAction(sender: ASButtonNode) {
        self.didSelectCameraAction?(sender.view.tag)
    }
    
    @objc func photoAction(sender: ASButtonNode) {
        self.didSelectPhotoAction?(sender.view.tag)
    }
    
    @objc func photoDeleteAction(sender: ASButtonNode) {
        self.didSelectDeletePhotoAction?(sender.view.tag)
    }
}

private class ImagePresenterNode: ASDisplayNode {
    
    // MARK: - UI
    var deleteButton = ASButtonNode()
    var buttonCover = ASDisplayNode()
    var imageNode = ASImageNode()
    
    // MARK: - Init
    init(image: UIImage, button: ASButtonNode) {
        super.init()
        self.imageNode.image = image
        self.imageNode.style.preferredSize = CGSize(width: 80.0, height: 80.0)
        self.imageNode.clipsToBounds = true
        self.imageNode.cornerRadius = 40.0
        
        self.deleteButton = button
        
        self.buttonCover.backgroundColor = UIColor.selected
        self.buttonCover.cornerRadius = 27/2
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        self.deleteButton.style.preferredSize = CGSize(width: 27.0, height: 27.0)
        let fullButton = ASBackgroundLayoutSpec(child: self.deleteButton, background: self.buttonCover)
        
        let relative = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .start, sizingOption: [], child: fullButton)
        
        let back = ASBackgroundLayoutSpec(child: relative, background: self.imageNode)
        
        return back
    }
}

private class NewImagePresenterNode: ASDisplayNode {
    // MARK: - UI
    var cameraButton = ASButtonNode()
    var photoButton = ASButtonNode()
    
    // MARK: - Init
    init(camera: ASButtonNode, photo: ASButtonNode) {
        super.init()
        
        self.cameraButton = camera
        self.photoButton = photo
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let content = ASStackLayoutSpec.vertical()
        content.children = [self.cameraButton, self.photoButton]
        
        return content
    }
}
