//
//  SlidesViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SlidesViewController: UIViewController, ASPagerDelegate, ASPagerDataSource {

    // MARK: - UI
    var pagerNode: ASPagerNode!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var nextButton = NextButton()
    
    // MARK: - Variables
    var sliders = [(UIImage?, String)]()
    private let permissionsViewController = "permissionsViewController"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set sliders
        if !Database.manager.application.isShowWelcome && Database.manager.application.user.pro {
            self.sliders.append((nil, "pro"))
        }
        self.sliders.append((#imageLiteral(resourceName: "sldFirst"), Localizations.Welcome.Cards.first))
        self.sliders.append((#imageLiteral(resourceName: "sldSecond"), Localizations.Welcome.Cards.second))
        self.sliders.append((#imageLiteral(resourceName: "sldThird"), Localizations.Welcome.Cards.third))
        self.sliders.append((#imageLiteral(resourceName: "sldFourth"), Localizations.Welcome.Cards.fourth))
        self.sliders.append((nil, "last"))
        
        // Set pager node
        self.pagerNode = ASPagerNode()
        self.pagerNode.setDataSource(self)
        self.pagerNode.setDelegate(self)
        self.view.insertSubview(self.pagerNode.view, at: 0)
        
        // Page Control
        self.pageControl.numberOfPages = self.sliders.count
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.width.equalTo(60.0)
            make.trailing.equalTo(self.view).offset(-30.0)
            make.bottom.equalTo(self.view).offset(-20.0)
        }
        self.nextButton.addTarget(self, action: #selector(nextButtonAction(sender: )), for: .touchUpInside)
        self.nextButton.alpha = 0.0
        self.nextButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        self.nextButton.isAccessibilityElement = true
        self.nextButton.accessibilityLabel = "\(Localizations.Welcome.Cards.Last.More.title), \(Localizations.Welcome.Cards.Last.More.description)"
        self.nextButton.accessibilityHint = Localizations.Accessibility.Onboarding.hint
        
        self.pageControl.isAccessibilityElement = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.pagerNode.frame = self.view.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.observable()
    }
    
    // MARK: - ASPagerDataSource
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return self.sliders.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let item = self.sliders[index]
        switch item.1 {
        case "pro":
            return {
                return WelcomeBecomeProNode()
            }
        case "last":
            let isFirst = !Database.manager.application.isShowWelcome
            return {
                return WelcomeLastSlideNode(isFirst: isFirst, style: Themes.manager.slidesControllerStyle)
            }
        default:
            return {
                let node = WelcomeImageNode(image: item.0, text: item.1, style: Themes.manager.slidesControllerStyle)
                return node
            }
        }
    }
    
    // MARK: - ASPagerDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = self.pagerNode.currentPageIndex
        if Database.manager.application.isShowWelcome {
            if self.pagerNode.currentPageIndex == self.sliders.count - 1 {
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        } else {
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                if self.pagerNode.currentPageIndex == self.sliders.count - 1 {
                    self.nextButton.alpha = 1.0
                    self.nextButton.transform = CGAffineTransform.identity
                    self.pageControl.alpha = 0.0
                } else {
                    self.nextButton.alpha = 0.0
                    self.nextButton.transform = CGAffineTransform(translationX: 0.0, y: 100.0)
                    self.pageControl.alpha = 1.0
                }
            }, completion: nil)
        }
    }
    
    // MARK: - Actions
    @objc func nextButtonAction(sender: NextButton) {
        let presentingController = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: permissionsViewController)
        presentingController.transition = WelcomeTransition(animationDuration: 0.6)
        self.present(presentingController, animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.slidesControllerStyle
            
            // Set background
            self.view.backgroundColor = style.background
            self.pageControl.currentPageIndicatorTintColor = style.currentPageIndicatorColor
            self.pageControl.pageIndicatorTintColor = style.pageIndicatorColor
            
            self.pagerNode.backgroundColor = style.background
        })
    }
}
