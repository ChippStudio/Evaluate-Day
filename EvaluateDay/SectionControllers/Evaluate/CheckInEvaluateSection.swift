//
//  CheckInEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch
import RealmSwift

class CheckInEvaluateSection: ListSectionController, ASSectionController, EvaluableSection, SelectMapViewControllerDelegate {
    // MARK: - Variable
    var card: Card!
    var date: Date! {
        didSet {
            self.values = (self.card.data as! CheckInCard).values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).sorted(byKeyPath: "edited")
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    // MARK: - Private variables
    private var values: Results<LocationValue>!
    private var lock = false
    
    // MARK: - Actions
    var shareHandler: ((IndexPath, Card, [Any]) -> Void)?
    var didSelectItem: ((Int, Card) -> Void)?
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro {
            self.lock = true
        }
        
        if self.card.archived {
            lock = true
        }
        
        let title = self.card.title
        let subtitle = self.card.subtitle
        let image = Sources.image(forType: self.card.type)
        let archived = self.card.archived
        
        var datas = [(street: String, otherAddress: String, coordinates: String, index: Int)]()
        
        for (i, itemValue) in self.values.enumerated() {
            let street = itemValue.streetString
            let otherAddress = itemValue.otherAddressString
            let coordinates = itemValue.coordinatesString
            datas.append((street: street, otherAddress: otherAddress, coordinates: coordinates, index: i))
        }
        
        var permissions = false
        if Permissions.defaults.locationStatus != .authorizedWhenInUse {
            permissions = true
        }
        
        return {
            let node = CheckInNode(title: title, subtitle: subtitle, image: image, date: self.date, datas: datas, permissions: permissions, style: style)
                node.visual(withStyle: style)
            
            OperationQueue.main.addOperation {
                node.title.shareButton.view.tag = index
            }
            node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            for data in node.datas {
                data.didSelectItem = { (i) in
                    if self.lock {
                        return
                    }
                    
                    let controller = UIStoryboard(name: Storyboards.selectMap.rawValue, bundle: nil).instantiateInitialViewController() as! SelectMapViewController
                    controller.delegate = self
                    self.viewController?.present(controller, animated: true, completion: {
                        controller.selectedLocation = self.values[i]
                    })
                }
            }
            
            if node.permission != nil {
                node.permission.permissionButton.addTarget(self, action: #selector(self.allowLocationButtonAction(sender:)), forControlEvents: .touchUpInside)
                if !self.lock {
                    node.permission.mapButton.addTarget(self, action: #selector(self.selectOnMapAction(sender:)), forControlEvents: .touchUpInside)
                }
            } else if node.checkin != nil {
                if !self.lock {
                    node.checkin.checkInButton.addTarget(self, action: #selector(self.checkInAction(sender:)), forControlEvents: .touchUpInside)
                    node.checkin.mapButton.addTarget(self, action: #selector(self.selectOnMapAction(sender:)), forControlEvents: .touchUpInside)
                }
            }
            
            if archived {
                node.backgroundColor = style.cardArchiveColor
            }
            
            return node
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
        }
        
        let max = CGSize(width: width - collectionViewOffset, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width - collectionViewOffset, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if index != 0 {
            return
        }
        
        self.didSelectItem?(self.section, self.card)
    }
    // MARK: - SelectMapViewControllerDelegate
    func selectLocation(controller: SelectMapViewController, locationValue value: LocationValue?) {
        guard let value = value else {
            return
        }
        
        if value.realm == nil {
            value.owner = self.card.id
            value.created = self.date
        }
        
        controller.dismiss(animated: true, completion: nil)
        try! Database.manager.data.write {
            if value.realm != nil {
                value.edited = Date()
            }
            Database.manager.data.add(value, update: true)
        }
        
        self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    func deleteLocation(controller: SelectMapViewController, locationValue value: LocationValue?) {
        guard let value = value else {
            return
        }
        
        if value.realm == nil {
            return
        }
        
        controller.dismiss(animated: true, completion: nil)
        try! Database.manager.data.write {
            value.edited = Date()
            value.isDeleted = true
        }
        
        self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func allowLocationButtonAction(sender: ASButtonNode) {
        Permissions.defaults.locationAuthorize {
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    @objc private func checkInAction(sender: ASButtonNode) {
        if let loc = Permissions.defaults.currentLocation.value {
            let locationValue = LocationValue()
            locationValue.location = loc
            locationValue.created = self.date
            locationValue.owner = self.card.id
            locationValue.locationInformation(completion: { (street, city, state, country) in
                locationValue.street = street
                locationValue.city = city
                locationValue.state = state
                locationValue.country = country
                
                try! Database.manager.data.write {
                    Database.manager.data.add(locationValue)
                }
                self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                    batchContext.reload(self)
                }, completion: nil)
            })
        }
    }
    @objc private func selectOnMapAction(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.selectMap.rawValue, bundle: nil).instantiateInitialViewController() as! SelectMapViewController
        controller.delegate = self
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    @objc private func shareAction(sender: ASButtonNode) {
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        
        // Make shareble view
        var places = [LocationValue]()
        for v in self.values {
            places.append(v)
        }
        let inView = EvaluateCheckInShareView(places: places, title: self.card.title, subtitle: self.card.subtitle, date: self.date)
        
        // Share Image
        let sv = ShareView(view: inView)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(sv)
        sv.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        sv.layoutIfNeeded()
        
        var items = [Any]()
        if let im = sv.snapshot {
            items.append(im)
        }
        
        sv.removeFromSuperview()
        
        // Make universal Branch Link
        let linkObject = BranchUniversalObject(canonicalIdentifier: "chekInShare")
        linkObject.title = Localizations.share.link.title
        linkObject.contentDescription = Localizations.share.description
        
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "Content share"
        linkProperties.channel = "Evaluate"
        
        linkObject.getShortUrl(with: linkProperties) { (link, error) in
            if error != nil && link == nil {
                print(error!.localizedDescription)
            } else {
                items.append(link!)
            }
            
            self.shareHandler?(indexPath, self.card, items)
        }
    }
}

class CheckInNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var datas = [CheckInDataEvaluateNode]()
    var checkin: CheckInActionNode!
    var permission: CheckInPermissionNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, date: Date, datas: [(street: String, otherAddress: String, coordinates: String, index: Int)], permissions: Bool, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        for data in datas {
            let dataNode = CheckInDataEvaluateNode(street: data.street, otherAddress: data.otherAddress, coordinates: data.coordinates, index: data.index, style: style)
            self.datas.append(dataNode)
        }
        
        if permissions {
            self.permission = CheckInPermissionNode(date: date, style: style)
        } else {
            self.checkin = CheckInActionNode(date: date, style: style)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title]
        
        for data in self.datas {
            stack.children!.append(data)
        }
        
        if self.checkin != nil {
            stack.children!.append(self.checkin)
        } else if self.permission != nil {
            stack.children!.append(self.permission)
        }
        
        return stack
    }
}
