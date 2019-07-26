//
//  SettingsShortcutsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/07/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

@available(iOS 12.0, *)
class SettingsShortcutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private var cardsShortcuts = [(String, [Shortcut])]()
    private let suggestionCell = "suggestionCell"
    private let siriCell = "siriCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.title = Localizations.Siri.Settings.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShortcuts()
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // tableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cardsShortcuts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardsShortcuts[section].1.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cardsShortcuts[indexPath.section].1[indexPath.row]
        if item.voiceShortcuts != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: siriCell, for: indexPath) as! SettingsSiriEditShortcutCell
            cell.titleLabel.text = item.voiceShortcuts?.shortcut.userActivity?.title
            cell.phrase.text = "\"" + item.voiceShortcuts!.invocationPhrase + "\""
            
            let selView = UIView()
            selView.layer.cornerRadius = 5.0
            selView.backgroundColor = UIColor.tint
            
            cell.selectedBackgroundView = selView
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: suggestionCell, for: indexPath) as! SettingsSiriAddShortcutCell
            cell.titleLabel.text = item.suggestion?.title
            
            let selView = UIView()
            selView.layer.cornerRadius = 5.0
            selView.backgroundColor = UIColor.tint
            
            cell.selectedBackgroundView = selView
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.cardsShortcuts[indexPath.section].1[indexPath.row]
        if item.voiceShortcuts != nil {
            let controller = INUIEditVoiceShortcutViewController(voiceShortcut: item.voiceShortcuts!)
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            let controller = INUIAddVoiceShortcutViewController(shortcut: INShortcut(userActivity: item.suggestion!))
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.cardsShortcuts[section].0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.text
        header.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    // MARK: - INUIAddVoiceShortcutViewControllerDelegate
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        self.setShortcuts()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - INUIEditVoiceShortcutViewControllerDelegate
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        self.setShortcuts()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        self.setShortcuts()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    private func setShortcuts() {

        INVoiceShortcutCenter.shared.getAllVoiceShortcuts { (shortcuts, error) in
            
            OperationQueue.main.addOperation {
                if shortcuts == nil {
                    return
                }
                
                self.cardsShortcuts.removeAll()
                
                for card in Database.manager.data.objects(Card.self).filter(Sources.predicate).sorted(byKeyPath: Sources.sorted, ascending: Sources.ascending) {
                    var section = (card.title, [Shortcut]())
                    if let suggestions = card.data.suggestions {
                        for suggest in suggestions {
                            var voiceShortcut: INVoiceShortcut?
                            for vs in shortcuts! {
                                if let voiceActivity = vs.shortcut.userActivity {
                                    if voiceActivity.activityType == suggest.activityType {
                                        if voiceActivity.userInfo?["card"] as? String == suggest.userInfo?["card"] as? String {
                                            voiceShortcut = vs
                                        }
                                    }
                                }
                            }
                            if voiceShortcut != nil {
                                section.1.append(Shortcut(voiceShortcuts: voiceShortcut, suggestion: nil))
                            } else {
                                section.1.append(Shortcut(voiceShortcuts: nil, suggestion: suggest))
                            }
                        }
                    }
                    
                    if !section.1.isEmpty {
                        self.cardsShortcuts.append(section)
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    private struct Shortcut {
        var voiceShortcuts: INVoiceShortcut?
        var suggestion: NSUserActivity?
    }
}
