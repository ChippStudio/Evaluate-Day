//
//  TourViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SnapKit

class TourViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - UI
    var pageController: UIPageViewController!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var addCardsSetButton: UIButton!
    
    // MARK: - Variables
    var slidersData = [(image: UIImage?, title: String, description: String)]()
    private let slideControllerID = "slideControllerID"
    private let newsletterSegue = "newsletterSegue"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set sliders data
        self.slidersData.append((image: UIImage(named: "dashboard-3"), title: Localizations.Onboarding.Tour.Welcome.title, description: Localizations.Onboarding.Tour.Welcome.description))
        self.slidersData.append((image: UIImage(named: "dashboard-7"), title: Localizations.Onboarding.Tour.Cards.title, description: Localizations.Onboarding.Tour.Cards.description))
        self.slidersData.append((image: UIImage(named: "dashboard-27"), title: Localizations.Onboarding.Tour.Collections.title, description: Localizations.Onboarding.Tour.Collections.description))
        self.slidersData.append((image: UIImage(named: "dashboard-17"), title: Localizations.Onboarding.Tour.Analytics.title, description: Localizations.Onboarding.Tour.Analytics.description))
        self.slidersData.append((image: UIImage(named: "dashboard-30"), title: Localizations.Onboarding.Tour.CardsSet.title, description: Localizations.Onboarding.Tour.CardsSet.description))
        
        // Set page controll
        self.pageControl.numberOfPages = self.slidersData.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.main
        self.pageControl.currentPageIndicatorTintColor = UIColor.selected
        
        // Set buttons
        self.skipButton.setTitleColor(UIColor.main, for: .normal)
        self.skipButton.setTitle(Localizations.General.skip, for: .normal)
        
        self.addCardsSetButton.backgroundColor = UIColor.main
        self.addCardsSetButton.layer.cornerRadius = 7.0
        self.addCardsSetButton.setTitleColor(UIColor.textTint, for: .normal)
        self.addCardsSetButton.setTitle(Localizations.Onboarding.Tour.CardsSet.button, for: .normal)
        
        self.skipButton.alpha = 0.0
        self.addCardsSetButton.alpha = 0.0
        
        // Set page view controller
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController.delegate = self
        self.pageController.dataSource = self
        self.pageController.willMove(toParentViewController: self)
        self.view.insertSubview(self.pageController.view, at: 0)
        self.pageController.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        let controller = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: slideControllerID) as! SlideViewController
        controller.index = 0
        controller.image = self.slidersData[0].image
        controller.titleString = self.slidersData[0].title
        controller.descriptionString = self.slidersData[0].description
        self.pageController.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        
        // Set main style
        self.view.backgroundColor = UIColor.background
        self.pageController.view.backgroundColor = UIColor.background
        
        sendEvent(Analytics.startOnboarding, withProperties: nil)
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let slide = viewController as? SlideViewController else {
            return nil
        }
        let newIndex = slide.index - 1
        if newIndex < 0 {
            return nil
        }
        
        let controller = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: slideControllerID) as! SlideViewController
        controller.titleString = self.slidersData[newIndex].title
        controller.descriptionString = self.slidersData[newIndex].description
        controller.image = self.slidersData[newIndex].image
        controller.index = newIndex
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let slide = viewController as? SlideViewController else {
            return nil
        }
        let newIndex = slide.index + 1
        if newIndex >= self.slidersData.count {
            return nil
        }
        
        let controller = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: slideControllerID) as! SlideViewController
        controller.titleString = self.slidersData[newIndex].title
        controller.descriptionString = self.slidersData[newIndex].description
        controller.image = self.slidersData[newIndex].image
        controller.index = newIndex
        return controller
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let slide = pageViewController.viewControllers!.first as? SlideViewController else {
            return
        }
        self.pageControl.currentPage = slide.index
        if slide.index == self.slidersData.count - 1 {
            UIView.animate(withDuration: 0.3) {
                self.skipButton.alpha = 1.0
                self.addCardsSetButton.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.skipButton.alpha = 0.0
                self.addCardsSetButton.alpha = 0.0
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func skipButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.newsletterSegue, sender: self)
    }
    @IBAction func addCardsSet(_ sender: UIButton) {
        if !Database.manager.data.objects(Card.self).filter("isDeleted=%@", false).isEmpty {
            self.performSegue(withIdentifier: self.newsletterSegue, sender: self)
            return
        }
        
        // Set new collection
        let collection = Dashboard()
        collection.title = Localizations.Onboarding.Tour.CardsSet.collection
        
        // Add productivity card
        let productivityCard = Card()
        productivityCard.type = .criterionHundred
        productivityCard.title = Localizations.Demo.Criterion.Hundred.title
        productivityCard.subtitle = Localizations.Demo.Criterion.Hundred.subtitle
        productivityCard.order = Database.manager.data.objects(Card.self).count
        productivityCard.dashboard = collection.id
        
        // Add phrase card
        let phraseCard = Card()
        phraseCard.title = Localizations.New.Phrase.title
        phraseCard.subtitle = Localizations.New.Phrase.subtitle
        phraseCard.type = .phrase
        phraseCard.order = Database.manager.data.objects(Card.self).count
        phraseCard.dashboard = collection.id
        
        // Make data
        var values = [TextValue]()
        var components = DateComponents()
        for (i, t) in defaultPhrases.enumerated() {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = TextValue()
                value.created = newDate
                value.text = t
                value.owner = phraseCard.id
                values.append(value)
            }
        }
        
        // Add counter card
        let counterCard = Card()
        counterCard.title = Localizations.Demo.Counter.title
        counterCard.subtitle = Localizations.Demo.Counter.subtitle
        counterCard.type = .counter
        counterCard.order = Database.manager.data.objects(Card.self).count
        counterCard.dashboard = collection.id
        
        try! Database.manager.data.write {
            Database.manager.data.add(collection)
            Database.manager.data.add(productivityCard)
            Database.manager.data.add(phraseCard)
            Database.manager.data.add(counterCard)
            Database.manager.data.add(values)
        }
        self.performSegue(withIdentifier: self.newsletterSegue, sender: self)
    }
}
