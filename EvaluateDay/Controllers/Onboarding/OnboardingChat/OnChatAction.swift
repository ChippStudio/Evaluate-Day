//
//  OnChatAction.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 22/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

@objc protocol OnChatActionDelegate {
    func chatAction(action: OnChatAction, insertChatAt indexPath: IndexPath)
    func chatAction(action: OnChatAction, updateChatAt indexPath: IndexPath)
    func chatAction(action: OnChatAction, showAction view: UIView)
    func chatAction(action: OnChatAction, hideAction view: UIView)
    func chatAction(didFinishAction action: OnChatAction)
}

public class OnChatAction: NSObject {
    
    // MARK: - Public
    public var answerMessage: String!
    public let actionView: UIView
    
    // MARK: - Internal Variables
    weak var delegate: OnChatActionDelegate?
    var index: Int = 0
    let messages: [String]
    
    // MARK: - Private Variables
    private var handler: ((_ action: OnChatAction) -> Void)?
    
    private var isAnimation = false
    private var runIndex = -1
    private var timer: Timer!
    
    // MARK: - Init
    public init(messages: [String], actionView: UIView, handler: ((_ action: OnChatAction) -> Void)?) {
        self.messages = messages
        self.actionView = actionView
        
        super.init()
        self.handler = handler
    }
    
    // MARK: - Public actions
    public func resumeAction(withMessage message: String) {
        self.answerMessage = message
        self.delegate?.chatAction(action: self, insertChatAt: IndexPath(row: self.runIndex, section: self.index))
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (_) in
            self.delegate?.chatAction(didFinishAction: self)
        })
    }
    
    // MARK: - Internal Actions and Variables
    func startAction() {
        self.startAnimationCell()
    }
    
    var numberOfRows: Int {
        return self.runIndex + 1
    }
    
    func message(forRow row: Int) -> String {
        if row == self.messages.count {
            return self.answerMessage
        }
//        print("IndexPath = \(row): \(self.index)")
        return self.messages[row]
    }
    
    func type(ofRow row: Int) -> OnCellType {
        
        if self.isAnimation {
            return .animation
        }
        if row == self.messages.count {
            return .answer
        }
        
        return .message
    }
    
    // MARK: - Private Actions
    private func startAnimationCell() {
        self.runIndex += 1
        self.isAnimation = true
        self.delegate?.chatAction(action: self, insertChatAt: IndexPath(row: runIndex, section: index))
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
            self.showMessageCell()
        })
    }
    
    private func showMessageCell() {
        // Show Message
        self.isAnimation = false
        self.delegate?.chatAction(action: self, updateChatAt: IndexPath(row: self.runIndex, section: index))
        if self.runIndex + 1 < self.messages.count {
            self.startAnimationCell()
        } else {
            // Show action view and wait the answer
            if let av = self.actionView as? ActionView {
                av.complition = { (message) in
                    self.answerMessage = message
                    if self.runIndex < self.messages.count {
                        self.runIndex += 1
                        self.delegate?.chatAction(action: self, hideAction: self.actionView)
                        self.handler?(self)
                    }
                }
            }
            self.showActionView()
        }
    }
    
    private func showActionView() {
        self.delegate?.chatAction(action: self, showAction: self.actionView)
    }
}
