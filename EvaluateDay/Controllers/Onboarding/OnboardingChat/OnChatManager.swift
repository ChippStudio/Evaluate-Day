//
//  OnChatManager.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 22/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

public class OnChatManager: NSObject {

    // MARK: - Variables
    public let tableView: UITableView
    public let viewController: UIViewController
    public private(set) var isInAction = false
    
    // MARK: - Appearance
    public var messageBubbleColor: UIColor = UIColor.lightGray
    public var messageTitleColor: UIColor = UIColor.white
    public var messageTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    public var answerBubbleColor: UIColor = UIColor.green
    public var answerTitleColor: UIColor = UIColor.white
    public var answerTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    public var animationImage: UIImage?
    public var animationImageTintColor: UIColor?
    
    // MARK: - Delegate
    public weak var delegate: OnChatManagerDelegate?
    
    // MARK: - Private Variables
    private var actions = [OnChatAction]()
    
    private let questenCellIdentifire = "questenCell"
    private let answerCellIdentifire = "answerCell"
    private let animationCellIdentifire = "animationCell"
    
    private var actionViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    init(inViewController: UIViewController, with tableView: UITableView) {
        self.tableView = tableView
        self.viewController = inViewController
        
        super.init()
        
        // Set table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
//        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tableView.frame.size.height/2, right: 0.0)
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(sender:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    // MARK: - Public Actions
    public func startChatFlow() {
        
        if self.isInAction {
            return
        }
        
        // Register cells for table view
        if let questenCell = self.delegate?.onChatManager?(manager: self, registerCellFor: .message) {
            self.tableView.register(questenCell, forCellReuseIdentifier: questenCellIdentifire)
        } else {
            self.tableView.register(OnChatMessageCell.classForCoder(), forCellReuseIdentifier: questenCellIdentifire)
        }
        
        if let answerCell = self.delegate?.onChatManager?(manager: self, registerCellFor: .answer) {
            self.tableView.register(answerCell, forCellReuseIdentifier: answerCellIdentifire)
        } else {
            self.tableView.register(OnChatAnswerCell.classForCoder(), forCellReuseIdentifier: answerCellIdentifire)
        }
        
        if let animationCell = self.delegate?.onChatManager?(manager: self, registerCellFor: .animation) {
            self.tableView.register(animationCell, forCellReuseIdentifier: animationCellIdentifire)
        } else {
            self.tableView.register(OnChatLoadCell.classForCoder(), forCellReuseIdentifier: animationCellIdentifire)
        }
        
        if !self.actions.isEmpty {
            self.actions[0].startAction()
            self.isInAction = true
        }
    }
    
    public func addAction(action: OnChatAction) {
        action.delegate = self
        action.index = self.actions.count
        self.actions.append(action)
    }
    
    // MARK: - Keyboard actions
    @objc func keyboardWillShow(sender: Notification) {
        let height = (sender.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height
        
        if self.actionViewBottomConstraint != nil {
            UIView.animate(withDuration: 0.2) {
                self.tableView.contentInset.bottom += height
                self.actionViewBottomConstraint.constant = -height
            }
        }

        self.viewController.view.layoutIfNeeded()
    }

    @objc func keyboardDidHide(sender: Notification) {
        let height = (sender.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height

        if self.actionViewBottomConstraint != nil {
            UIView.animate(withDuration: 0.2) {
                self.tableView.contentInset.bottom -= height
                self.actionViewBottomConstraint.constant = 0.0
            }
        }

        self.viewController.view.layoutIfNeeded()
    }
}

extension OnChatManager: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.actions.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let action = self.actions[section]
        print(action.numberOfRows)
        return action.numberOfRows
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = self.actions[indexPath.section]
        switch action.type(ofRow: indexPath.row) {
        case .animation:
            let cell = tableView.dequeueReusableCell(withIdentifier: animationCellIdentifire, for: indexPath)
            if let aCell = cell as? OnChatLoadCell {
                if self.animationImageTintColor == nil {
                    aCell.icon.image = self.animationImage
                } else {
                    aCell.icon.image = self.animationImage?.withRenderingMode(.alwaysTemplate)
                    aCell.icon.tintColor = self.animationImageTintColor!
                }
                
            }
            cell.selectionStyle = .none
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: answerCellIdentifire, for: indexPath)
            if let aCell = cell as? OnChatBubbleCell {
                aCell.titleLabel.text = action.message(forRow: indexPath.row)
            }
            
            if let aCell = cell as? OnChatAnswerCell {
                aCell.cover.backgroundColor = self.answerBubbleColor
                aCell.titleLabel.textColor = self.answerTitleColor
                aCell.titleLabel.font = self.answerTitleFont
            }
            
            cell.selectionStyle = .none
            return cell
        case .message:
            let cell = tableView.dequeueReusableCell(withIdentifier: questenCellIdentifire, for: indexPath)
            if let mCell = cell as? OnChatBubbleCell {
                mCell.titleLabel.text = action.message(forRow: indexPath.row)
            }
            
            if let mCell = cell as? OnChatMessageCell {
                mCell.cover.backgroundColor = self.messageBubbleColor
                mCell.titleLabel.textColor = self.messageTitleColor
                mCell.titleLabel.font = self.messageTitleFont
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension OnChatManager: OnChatActionDelegate {
    func chatAction(action: OnChatAction, hideAction view: UIView) {
        view.removeFromSuperview()
        self.tableView.contentInset.bottom = 0.0
        self.actionViewBottomConstraint = nil
    }
    func chatAction(action: OnChatAction, showAction view: UIView) {
        // Show Action view and wait answer from it
        view.alpha = 0.0
        self.viewController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.viewController.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        self.actionViewBottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.viewController.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        self.viewController.view.addConstraints([left, right, self.actionViewBottomConstraint])
        
        view.layoutIfNeeded()
        
        view.transform = CGAffineTransform(translationX: 0.0, y: view.frame.size.height + 60)
        view.alpha = 1.0
        self.tableView.contentInset.bottom = view.frame.height
        UIView.animate(withDuration: 0.5) {
            view.transform = CGAffineTransform.identity
        }
        
        // Set index path
        let indexPath = IndexPath(row: action.messages.count - 1, section: action.index)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func chatAction(didFinishAction action: OnChatAction) {
        if action.index + 1 < self.actions.count {
            self.actions[action.index + 1].startAction()
        }
    }
    
    func chatAction(action: OnChatAction, insertChatAt indexPath: IndexPath) {
        let direction = action.type(ofRow: indexPath.row) == .answer ? UITableView.RowAnimation.right : UITableView.RowAnimation.left
        self.tableView.insertRows(at: [indexPath], with: direction)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func chatAction(action: OnChatAction, updateChatAt indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
