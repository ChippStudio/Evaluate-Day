//
//  Sounds.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum SoundType: String {
    case evaluateButton
    case evaluateCard
    case saveNewCard
    case deleteCard
    case openAnalytics
    case selectValue
    case openPro
    case closeSettings
}

final class Feedback {
    // MARK: - Singleton
    static var player = Feedback()
    
    // MARK: - Variables
    private var soundPlayer = AVAudioPlayer()
    private var selectGenerator = UISelectionFeedbackGenerator()
    private var notificationGenerator = UINotificationFeedbackGenerator()
    private var impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Init
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.ambient)), mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
        }
    }
    
    // MARK: - Actions
    func play(sound soundType: SoundType? = nil, hapticFeedback select: Bool = false, impact: Bool = false, feedbackType: UINotificationFeedbackGenerator.FeedbackType? = nil) {
        if soundType != nil {
            self.play(sound: soundType!)
        }
        if select {
            self.select()
        } else if impact {
            self.impact()
        } else {
            if feedbackType != nil {
                self.notify(type: feedbackType!)
            }
        }
    }
    private func play(sound type: SoundType) {
        if !Database.manager.application.settings.sound {
            return
        }
        if let soundURL = Bundle.main.url(forResource: type.rawValue, withExtension: "wav") {
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                soundPlayer.prepareToPlay()
                soundPlayer.play()
            } catch {
                print("Cant Play sound")
            }
        } else {
            print("No sound file")
        }
    }
    
    // MARK: - Haptic Feedback
    func select() {
        self.selectGenerator.prepare()
        self.selectGenerator.selectionChanged()
    }
    func notify(type: UINotificationFeedbackGenerator.FeedbackType) {
        self.notificationGenerator.prepare()
        self.notificationGenerator.notificationOccurred(type)
    }
    func impact() {
        self.impactGenerator.prepare()
        self.impactGenerator.impactOccurred()
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
