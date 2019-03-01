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
    @IBOutlet weak var proLimitLabel: UILabel!
    @IBOutlet weak var proView: ProView!
    
    // MARK: - Variables
    
    var cardType: CardType!
    var collectionID: String!
    
    private let sources = Sources()
    private let newCardCell = "newCardCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation bar
        self.navigationItem.title = Localizations.New.Controller.title
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        self.proLimitLabel.textColor = UIColor.main
        self.proLimitLabel.text = Localizations.New.Cards.Limit.message(cardsLimit)
        
        self.proView.button.addTarget(self, action: #selector(openProAction(sender:)), for: .touchUpInside)
        
        self.tableView.showsVerticalScrollIndicator = false
        
        if Store.current.isPro {
            self.tableView.tableHeaderView = nil
        }
        
        // Analytics
        sendEvent(.openNewCardSelector, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.cardType != nil {
            self.makeNewCard(withType: self.cardType)
            self.cardType = nil
        }
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
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            }
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sources.groupedCards.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sources.groupedCards[section].cards.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newCardCell, for: indexPath) as! NewCardCell
        let source = self.sources.groupedCards[indexPath.section].cards[indexPath.row]
        
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
        
        let source = self.sources.groupedCards[indexPath.section].cards[indexPath.row]
        self.makeNewCard(withType: source.type)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sources.groupedCards[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.textLabel?.textColor = UIColor.text
        footer.textLabel!.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.text
        header.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    // MARK: - Actions
    func makeNewCard(withType type: CardType) {
        let newCard = Card()
        newCard.type = type
        newCard.order = Database.manager.data.objects(Card.self).count
        if self.collectionID != nil {
            newCard.dashboard = collectionID
        }
        if newCard.data as? Editable != nil {
            let controller = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
            controller.card = newCard
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @objc func openProAction(sender: UIButton) {
        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
        self.universalSplitController?.pushSideViewController(controller)
    }
}
