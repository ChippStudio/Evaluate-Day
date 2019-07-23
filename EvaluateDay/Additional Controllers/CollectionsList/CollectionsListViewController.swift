//
//  CollectionsListViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import AsyncDisplayKit

@objc protocol CollectionsListViewControllerDelegate {
    func collectionList(controller: CollectionsListViewController, didSelectCollection collectionId: String)
}

class CollectionsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    var addNewCollectionButton: UIBarButtonItem!
    var emptyView = EmptyView()
    
    // MARK: - Variables
    var collections: Results<Dashboard>!
    
    weak var delegate: CollectionsListViewControllerDelegate?
    private let collectionListCell = "collectionListCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.Collection.title
        
        // set empty view
        self.emptyView.imageView.image = Images.Media.collections.image.withRenderingMode(.alwaysTemplate)
        self.emptyView.titleLabel.text = Localizations.Collection.Empty.List.title
        self.emptyView.descriptionLabel.text = Localizations.Collection.Empty.List.description
        self.emptyView.button.setTitle(Localizations.Collection.addNew, for: .normal)
        self.emptyView.button.addTarget(self, action: #selector(self.newCollectionButtonAction(sender:)), for: .touchUpInside)

        self.collections = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false)
        
        // Set add new button
        self.addNewCollectionButton = UIBarButtonItem(image: Images.Media.new.image.resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.newCollectionButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = self.addNewCollectionButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
        
        if self.collections.isEmpty {
            self.tableView.alpha = 0.0
            self.view.addSubview(self.emptyView)
            self.emptyView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        } else {
            self.tableView.alpha = 1.0
            self.emptyView.removeFromSuperview()
        }
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
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collections.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.collections[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: collectionListCell, for: indexPath) as! CollectionsListCell
        cell.collectionImage.image = UIImage(named: item.image)
        cell.collectionTitle.text = item.title
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.collections[indexPath.row]
        
        self.delegate?.collectionList(controller: self, didSelectCollection: item.id)
    }
    
    // MARK: - Actions
    @objc func newCollectionButtonAction(sender: AnyObject) {
        if let split = self.universalSplitController as? SplitController {
            let controller = UIStoryboard(name: Storyboards.editCollection.rawValue, bundle: nil).instantiateInitialViewController()!
            split.pushSideViewController(controller, complition: nil)
        }
    }
}
