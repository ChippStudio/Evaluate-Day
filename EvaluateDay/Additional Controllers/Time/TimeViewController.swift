//
//  TimeViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

class TimeViewController: UIViewController, ListAdapterDataSource {

    // MARK: - UI
    @IBOutlet weak var closeButtonCover: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var datePickerCover: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var collectionNode: ASCollectionNode!
    
    // MARK: - Variables
    var card: Card!
    var date = Date() {
        didSet {
            self.adapter.performUpdates(animated: true) { (done) in
                if done {
                    if var section = self.adapter.sectionController(for: DiffCard(card: self.card)) as? EvaluableSection {
                        section.date = self.date
                        (section as! ListSectionController).collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                            batchContext.reload(section as! ListSectionController)
                        }, completion: nil)
                    }
                }
            }
        }
    }
    var adapter: ListAdapter!
    let proLockObject = ProLock()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection view
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.accessibilityIdentifier = "evaluateCollection"
        self.view.insertSubview(self.collectionNode.view, at: 0)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
        
        // Styles
        let style = Themes.manager.evaluateStyle
        
        self.view.backgroundColor = style.background
        self.collectionNode.backgroundColor = style.background
        self.closeButtonCover.backgroundColor = style.background
        self.datePickerCover.backgroundColor = style.background
        
        self.closeButton.setImage(#imageLiteral(resourceName: "closeCircle").resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeButton.tintColor = style.barTint
        
        self.datePicker.setValue(style.barTint, forKey: "textColor")
        self.datePicker.maximumDate = Date()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionNode.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionNode.contentInset = UIEdgeInsets(top: self.closeButtonCover.frame.size.height + 10.0, left: 0.0, bottom: self.datePickerCover.frame.size.height + 10.0, right: 0.0)
    }
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableCards = [ListDiffable]()
        diffableCards.append(DiffCard(card: self.card))
        
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro && diffableCards.count != 0 {
            diffableCards.insert(self.proLockObject, at: 0)
        }
        
        return diffableCards
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if let object = object as? DiffCard {
            if object.data == nil {
                return ListSectionController()
            }
            
            let controller = object.data!.evaluateSectionController
            controller.inset = cardInsets
            if var cntrl = controller as? EvaluableSection {
                cntrl.date = self.date
                cntrl.didSelectItem = { (index, card) in
                    let analytycs = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
                    analytycs.card = card
                    self.navigationController?.pushViewController(analytycs, animated: true)
                }
            }
            return controller
        } else if object as? ProLock != nil {
            let section = ProLockSection()
            section.inset = cardInsets
            section.didSelectPro = { () in
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return section
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: - Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.date = sender.date
    }
}
