//
//  WebViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var webView: UIWebView!
    var closeButton: UIBarButtonItem!
    
    // MARK: - Variable
    var html: String!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation controller
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.gunmetal
        
        // set self
        self.view.backgroundColor = UIColor.white
        self.webView.backgroundColor = UIColor.white

        // Set close button
        self.closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(closeButtonAction(sender:)))
        self.closeButton.accessibilityLabel = Localizations.general.close
        self.navigationItem.setRightBarButton(self.closeButton, animated: false)
        
        // web view
        if html != nil {
            if let file = try? String(contentsOfFile: self.html, encoding: String.Encoding.utf8) {
                self.webView.loadHTMLString(file, baseURL: nil)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @objc func closeButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
