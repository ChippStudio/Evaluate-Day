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
