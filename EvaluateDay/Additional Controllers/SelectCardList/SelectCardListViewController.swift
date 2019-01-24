//
//  SelectCardListViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol SelectCardListViewControllerDelegate {
    @objc func  didSelect(cardId id: String, in cotroller: SelectCardListViewController)
}
class SelectCardListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    var cards: Results<Card>!
    weak var delegate: SelectCardListViewControllerDelegate?
    
    private let cardCell = "cardCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation item
        self.navigationItem.title = Localizations.Settings.Notifications.New.selectCard
        
        // TableView
        self.tableView.showsVerticalScrollIndicator = false
        
        // set cards
        self.cards = Database.manager.data.objects(Card.self).sorted(byKeyPath: "order")
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
            self.navigationController?.navigationBar.barTintColor = UIColor.background
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
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        selView.layer.cornerRadius = 5.0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCell, for: indexPath) as! CardRepresentCell
        
        let card = self.cards[indexPath.row]
        
        cell.cardTitleLabel?.text = card.title
        cell.cardSubtitleLabel?.text = card.subtitle
        cell.cardImageView?.image = Sources.image(forType: card.type).resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
        cell.cardImageView?.tintColor = UIColor.main
        cell.selectedBackgroundView = selView
        
        cell.collectionImageHeight.constant = 0.0
        cell.bottomOffset.constant = 0.0
        cell.collectionTitleLabel.text = nil
        cell.collectionImageView.image = nil
        
        if card.dashboard == nil {
            return cell
        }
        
        if let collection = Database.manager.data.objects(Dashboard.self).filter("id=%@ AND isDeleted=%@", card.dashboard!, false).first {
            cell.collectionImageHeight.constant = 30.0
            cell.bottomOffset.constant = 10.0
            cell.collectionTitleLabel.text = collection.title
            cell.collectionImageView.image = UIImage(named: collection.image)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.didSelect(cardId: self.cards[indexPath.row].id, in: self)
    }
}
