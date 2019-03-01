//
//  EditCollectionImagesViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

@objc protocol EditCollectionImagesViewControllerDelegate {
    func didSelectImageBy(name: String, in controller: EditCollectionImagesViewController)
}

class EditCollectionImagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    weak var delegate: EditCollectionImagesViewControllerDelegate?
    
    private let imageCell = "imageCell"
    
    var images = [String]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<35 {
            self.images.append("dashboard-\(i)")
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
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imageCell, for: indexPath) as! CollectionImageTableViewCell
        cell.collectionImageView.image = UIImage(named: self.images[indexPath.row])
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.tint
        
        cell.accessibilityLabel = "collection-\(indexPath.row)"
        
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.images[indexPath.row]
        
        self.delegate?.didSelectImageBy(name: item, in: self)
    }
}
