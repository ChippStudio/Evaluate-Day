//
//  NewCardViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class NewCardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    let sources = Sources()
    
    private let newCardCell = "newCardCell"
    private let proCell = "proCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation bar
        self.navigationItem.title = Localizations.New.Controller.title
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        self.tableView.showsVerticalScrollIndicator = false
        
        // Analytics
        sendEvent(.openNewCardSelector, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.view.backgroundColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if Store.current.isPro {
                return 0
            } else {
                return 1
            }
        }
        
        return self.sources.cards.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: proCell, for: indexPath) as! ProUnlockCell
            cell.descriptionLabel.text = Localizations.New.Cards.Limit.message(cardsLimit)
            cell.proView.button.addTarget(self, action: #selector(self.openProAction(sender:)), for: .touchUpInside)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newCardCell, for: indexPath) as! NewCardCell
        let source = self.sources.cards[indexPath.row]
        
        if Database.manager.data.objects(Card.self).filter("isDeleted=%@", false).count >= cardsLimit && !Store.current.isPro {
            cell.selectionStyle = .none
        } else {
            cell.selectionStyle = .default
        }
        
        cell.iconImageView.image = source.image.resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate)
        
        cell.titleLabel.text = source.title
        cell.subtitleLabel.text = source.subtitle
        
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        selView.layer.cornerRadius = 5.0
        
        cell.selectedBackgroundView = selView
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)!.selectionStyle == .none {
            return
        }
        
        let source = self.sources.cards[indexPath.row]
        let newCard = Card()
        newCard.type = source.type
        newCard.order = Database.manager.data.objects(Card.self).count
        if newCard.data as? Editable != nil {
            let controller = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
            controller.card = newCard
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func openProAction(sender: UIButton) {
        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
        self.universalSplitController?.pushSideViewController(controller)
    }
}
