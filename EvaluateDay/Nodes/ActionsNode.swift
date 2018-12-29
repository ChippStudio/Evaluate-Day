//
//  ActionsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ActionNodeStyle {
    var actionDeleteTintColor: UIColor { get }
    var actionEditTintColor: UIColor { get }
    var actionMergeTintColor: UIColor { get }
    var actionDividerColor: UIColor { get }
}

enum ActionsNodeAction: Int {
    case delete
    case settings
    case merge
    case camera
    case photo
}

class ActionsNode: ASCellNode {
    // MARK: - UI
    var actions = [ASButtonNode]()
    var topDivider: ASDisplayNode!
    var bottomDivider: ASDisplayNode!
    var dotDivider: ASDisplayNode!
    
    // MARK: - Variables
    var bottomOffset: CGFloat = 10.0
    
    // MARK: - Init
    init(actions: [ActionsNodeAction], isDividers: Bool = false, isBottomDivider: Bool = false, style: ActionNodeStyle) {
        super.init()
        
        if isDividers {
            self.topDivider = ASDisplayNode()
            self.dotDivider = ASDisplayNode()
            
            self.topDivider.backgroundColor = style.actionDividerColor
            self.dotDivider.backgroundColor = style.actionDividerColor
            
            self.topDivider.style.preferredSize = CGSize(width: 1.0, height: 15.0)
            self.dotDivider.style.preferredSize = CGSize(width: 20.0, height: 20.0)
            self.dotDivider.cornerRadius = 5.0
            
            if isBottomDivider {
                self.bottomDivider = ASDisplayNode()
                self.bottomDivider.backgroundColor = style.actionDividerColor
            }
        }
        
        for action in actions {
            switch action {
            case .delete:
                let deleteButton = ASButtonNode()
                deleteButton.setImage(#imageLiteral(resourceName: "delete").increaseSize(by: -5.0), for: .normal)
                deleteButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.actionDeleteTintColor)
                deleteButton.imageNode.contentMode = .scaleAspectFit
                OperationQueue.main.addOperation {
                    deleteButton.view.tag = action.rawValue
                }
                self.actions.append(deleteButton)
            case .settings:
                let editButton = ASButtonNode()
                editButton.setImage(#imageLiteral(resourceName: "settings").increaseSize(by: -5.0), for: .normal)
                editButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.actionEditTintColor)
                editButton.imageNode.contentMode = .scaleAspectFit
                OperationQueue.main.addOperation {
                    editButton.view.tag = action.rawValue
                }
                self.actions.append(editButton)
            case .merge:
                let mergeButton = ASButtonNode()
                mergeButton.setImage(#imageLiteral(resourceName: "merge"), for: .normal)
                mergeButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.actionMergeTintColor)
                mergeButton.imageNode.contentMode = .scaleAspectFit
                OperationQueue.main.addOperation {
                    mergeButton.view.tag = action.rawValue
                }
                self.actions.append(mergeButton)
            case .camera:
                let cameraButton = ASButtonNode()
                cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
                cameraButton.imageNode.contentMode = .scaleAspectFit
                OperationQueue.main.addOperation {
                    cameraButton.view.tag = action.rawValue
                }
                self.actions.append(cameraButton)
            case .photo:
                let photoButton = ASButtonNode()
                photoButton.setImage(#imageLiteral(resourceName: "selectPhoto"), for: .normal)
                photoButton.imageNode.contentMode = .scaleAspectFit
                OperationQueue.main.addOperation {
                    photoButton.view.tag = action.rawValue
                }
                self.actions.append(photoButton)
            }
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        for button in self.actions {
            button.style.preferredSize = CGSize(width: 50.0, height: 30.0)
        }
        
        let buttons = ASStackLayoutSpec.horizontal()
        buttons.spacing = 5.0
        buttons.alignContent = .end
        buttons.justifyContent = .end
        buttons.children = self.actions
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: self.bottomOffset, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: buttons)
        
        if self.topDivider != nil {
            let divides = ASStackLayoutSpec.vertical()
            divides.alignItems = .center
            divides.children = [self.topDivider, self.dotDivider]
            
            if self.bottomDivider != nil {
                self.bottomDivider.style.preferredSize = CGSize(width: 1.0, height: 20)
                divides.children!.append(self.bottomDivider)
            }
            
            let fullCell = ASStackLayoutSpec.horizontal()
            fullCell.spacing = 0.0
            fullCell.justifyContent = .end
            fullCell.children = [cellInset, divides]
            
            let fullCellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
            let fullCellInset = ASInsetLayoutSpec(insets: fullCellInsets, child: fullCell)
            
            return fullCellInset
        }
        
        return cellInset
    }
    
    // MARK: - Actions
    func button(forType type: ActionsNodeAction) -> ASButtonNode? {
        for b in self.actions {
            if ActionsNodeAction(rawValue: b.view.tag) == type {
                return b
            }
        }
        return nil
    }
}
