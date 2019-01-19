//
//  JournalAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FSCalendar
import SwiftyJSON
import Branch
import Charts

private enum AnalyticsNodeType {
    case title
    case information
    case calendar
    case map
    case bar
    case viewAll
    case export
}

class JournalAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection, FSCalendarDelegate, FSCalendarDelegateAppearance, MKMapViewDelegate {
    // MARK: - Variable
    var card: Card!
    
    private var data: [(title: String, data: String)]?
    private var nodes = [AnalyticsNodeType]()
    
    // MARK: - Actions
    var exportHandler: ((_ indexPath: IndexPath, _ index: Int, _ item: Any) -> Void)?
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
        
        self.nodes.append(.title)
        self.nodes.append(.information)
        self.nodes.append(.map)
        self.nodes.append(.calendar)
        self.nodes.append(.viewAll)
        self.nodes.append(.bar)
        self.nodes.append(.export)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.analyticalStyle
        let nodeType = self.nodes[index]
        let isPro = Store.current.isPro
        switch nodeType {
        case .title:
            let title = self.card.title
            let subtitle = self.card.subtitle
            let image = Sources.image(forType: self.card.type)
            return {
                let node = TitleNode(title: title, subtitle: subtitle, image: image)
                
                return node
            }
        case .map:
            return {
                let node = AnalyticsMapNode(title: Localizations.Analytics.Journal.near.uppercased(), actionTitle: Localizations.Analytics.Checkin.Map.action)
                node.topInset = 20.0
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                node.actionButton!.addTarget(self, action: #selector(self.openMapAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                node.didLoadMap = { () in
                    for v in (self.card.data as! JournalCard).values {
                        if v.location != nil {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = v.location!.location.coordinate
                            node.mapView.addAnnotation(annotation)
                        }
                    }
                    node.mapView.delegate = self
                }
                return node
            }
        case .information:
            let journalCard = self.card.data as! JournalCard
            self.data = [(title: String, data: String)]()
            self.data!.append((title: Localizations.General.createDate + ":", data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            self.data!.append((title: Localizations.Analytics.Statistics.entries + ":", data: "\(journalCard.values.count)"))
            
            if isPro {
                var max: CLLocationDistance = 0.0
                var min: CLLocationDistance = 50000000.0
                
                var maxString: String?
                var minString: String?
                
                var maxCh = 0
                var minCh = 1000000
                var sum = 0
                
                for v in journalCard.values {
                    if v.location != nil {
                        if v.location!.distance > max {
                            max = v.location!.distance
                            maxString = v.location!.distanceString
                        }
                        if v.location!.distance < min {
                            min = v.location!.distance
                            minString = v.location!.distanceString
                        }
                    }
                    
                    if v.text.count > maxCh {
                        maxCh = v.text.count
                    }
                    if v.text.count < minCh {
                        minCh = v.text.count
                    }
                    sum += v.text.count
                }
                
                if maxString != nil {
                    self.data!.append((title: Localizations.Analytics.Statistics.maximum + ":", data: maxString!))
                }
                if minString != nil {
                    self.data!.append((title: Localizations.Analytics.Statistics.minimum + ":", data: minString!))
                }
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.total, data: "\(sum)"))
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.max, data: "\(maxCh)"))
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.min, data: "\(minCh)"))
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.average, data: String(format: "%.2f", Double(sum)/Double(journalCard.values.count))))
            } else {
                self.data!.append((title: Localizations.Analytics.Statistics.maximum + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.minimum + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.total, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.max, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.min, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.Characters.average, data: proPlaceholder))
            }
            return {
                let node = AnalyticsStatisticNode(data: self.data!)
                return node
            }
        case .calendar:
            return {
                let node = AnalyticsCalendarNode(title: Localizations.Analytics.Phrase.Calendar.title.uppercased(), isPro: isPro)
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                node.topInset = 20.0
                node.didLoadCalendar = { () in
                    node.calendar.delegate = self
                }
                return node
            }
        case .bar:
            let journalCard = self.card.data as! JournalCard
            let entries = journalCard.values.sorted(byKeyPath: "created", ascending: true)
            var data = [BarChartDataEntry]()
            var currentDate: Date = Date()
            var entriesCount = 0
            if let e = entries.first {
                currentDate = e.created
            }
            var ie = 0
            for (i, entry) in entries.enumerated() {
                if currentDate.start.days(to: entry.created.start) == 0 {
                    entriesCount += 1
                } else {
                    let chartDataEntry = BarChartDataEntry(x: Double(ie), y: Double(entriesCount), data: currentDate as AnyObject)
                    data.append(chartDataEntry)
                    ie += 1
                    entriesCount = 1
                    currentDate = entry.created
                }
                
                if i == entries.count - 1 {
                    let chartDataEntry = BarChartDataEntry(x: Double(ie), y: Double(entriesCount), data: currentDate as AnyObject)
                    data.append(chartDataEntry)
                }
            }
            let opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            return {
                let node = AnalyticsBarChartNode(title: Localizations.Analytics.Journal.barEntries, data: data, options: opt, isPro: isPro, style: style)
                node.chartStringForValue = { (node, value, axis) in
                    return ""
                }
                node.topOffset = 20.0
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .viewAll:
            return {
                let node = SettingsProButtonNode(title: Localizations.Analytics.Journal.viewAll)
                node.topInset = 20.0
                return node
            }
        case .export:
            return {
                let node = AnalyticsExportNode(types: [.csv, .json, .txt], title: Localizations.Analytics.Export.title.uppercased(), action: Localizations.Analytics.Export.action.uppercased())
                node.topOffset = 50.0
                node.didSelectType = { (type, cellIndexPath, index) in
                    if isPro {
                        self.export(withType: type, indexPath: cellIndexPath, index: index)
                    } else {
                        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                        if let nav = self.viewController?.parent as? UINavigationController {
                            nav.pushViewController(controller, animated: true)
                        }
                    }
                }
                return node
            }
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
        }
        
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if self.nodes[index] == .viewAll {
            let controller = UIStoryboard(name: Storyboards.entriesList.rawValue, bundle: nil).instantiateInitialViewController() as! EntriesListViewController
            controller.card = self.card
            
            if let nav = self.viewController?.parent as? UINavigationController {
                nav.pushViewController(controller, animated: true)
            }
        } else if self.nodes[index] == .calendar {
            if !Store.current.isPro {
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                if let nav = self.viewController?.parent as? UINavigationController {
                    nav.pushViewController(controller, animated: true)
                }
            }
        } else if self.nodes[index] == .bar {
            if !Store.current.isPro {
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                if let nav = self.viewController?.parent as? UINavigationController {
                    nav.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let journalCard = self.card.data as! JournalCard
        if journalCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first != nil {
            return UIColor.positive
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let jornalCard = self.card.data as! JournalCard
        if jornalCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first != nil {
            return UIColor.white
        }
        
        return nil
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if #available(iOS 11.0, *) {
            if let cluster = annotation as? MKClusterAnnotation {
                let view = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: "p")
                view.subtitleVisibility = .hidden
                view.titleVisibility = .hidden
                return view
            }
        }
        
        if annotation is MKUserLocation {
            return nil
        } else {
            if #available(iOS 11.0, *) {
                let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "d")
                view.clusteringIdentifier = "pd"
                return view
            } else {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "f")
                view.image = #imageLiteral(resourceName: "locationMark").resizedImage(newSize: CGSize(width: 30.0, height: 30.0))
                return view
            }
        }
    }
    
    // MARK: - Actions
    private func export(withType type: ExportType, indexPath: IndexPath, index: Int) {
        //export data
        switch type {
        case .csv:
            if let file = self.setCSV() {
                self.exportHandler?(indexPath, index, file as Any)
            }
        case .txt:
            if let file = self.setTXT() {
                self.exportHandler?(indexPath, index, file as Any)
            }
        case .json:
            if let file = self.setJson() {
                self.exportHandler?(indexPath, index, file as Any)
            }
        }
    }
    private func setCSV() -> URL? {
        let fileName = "\(self.card.title).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Text,Latitude,Longitude,Street,City,State,Country,Temperature,Apparent Temperature,Summary,Humidity,Pressure,Wind Speed,Cloud Cover\n"
        
        let journalCard = self.card.data as! JournalCard
        let sortedValues = journalCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            // set location
            var latitude = ""
            var longitude = ""
            var street = ""
            var city = ""
            var state = ""
            var country = ""
            
            if c.location != nil {
                latitude = "\(c.location!.latitude)"
                longitude = "\(c.location!.longitude)"
                street = c.location!.streetString
                city = c.location!.cityString
                state = c.location!.stateString
                country = c.location!.countryString
            }
            
            // set weather
            var temperature = ""
            var apparentTemperature = ""
            var summary = ""
            var humidity = ""
            var pressure = ""
            var windSpeed = ""
            var cloudCover = ""
            if c.weather != nil {
                temperature = "\(c.weather!.temperarure)"
                apparentTemperature = "\(c.weather!.apparentTemperature)"
                if !Database.manager.application.settings.celsius {
                    temperature = "\(String(format: "%.0f", (c.weather!.temperarure * (9/5) + 32)))"
                    apparentTemperature = "\(String(format: "%.0f", (c.weather!.apparentTemperature * (9/5) + 32)))"
                }
                summary = c.weather!.summary
                humidity = "\(c.weather!.humidity)"
                pressure = "\(c.weather!.pressure)"
                windSpeed = "\(c.weather!.windSpeed)"
                if !Locale.current.usesMetricSystem {
                    windSpeed = "\(c.weather!.windSpeed * (25/11))"
                }
                cloudCover = "\(c.weather!.cloudCover)"
            }
            
            newLine = "\(self.card.title),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),\(c.text),\(latitude),\(longitude),\(street), \(city), \(state), \(country), \(temperature), \(apparentTemperature), \(summary), \(humidity), \(pressure), \(windSpeed), \(cloudCover)\n"
            
            csvText.append(newLine)
        }
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
        
        return path
    }
    
    private func setTXT() -> URL? {
        let fileName = "\(self.card.title).txt"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var txtText = "Title, Created, 'Created - Since 1970', Edited, 'Edited - Since 1970', Text, Latitude, Longitude, Street, City, State, Country, Temperature, Apparent Temperature, Summary, Humidity, Pressure, Wind Speed, Cloud Cover\n"
        
        let journalCard = self.card.data as! JournalCard
        let sortedValues = journalCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            // set location
            var latitude = ""
            var longitude = ""
            var street = ""
            var city = ""
            var state = ""
            var country = ""
            
            if c.location != nil {
                latitude = "\(c.location!.latitude)"
                longitude = "\(c.location!.longitude)"
                street = c.location!.streetString
                city = c.location!.cityString
                state = c.location!.stateString
                country = c.location!.countryString
            }
            
            // set weather
            var temperature = ""
            var apparentTemperature = ""
            var summary = ""
            var humidity = ""
            var pressure = ""
            var windSpeed = ""
            var cloudCover = ""
            if c.weather != nil {
                temperature = "\(c.weather!.temperarure)"
                apparentTemperature = "\(c.weather!.apparentTemperature)"
                if !Database.manager.application.settings.celsius {
                    temperature = "\(String(format: "%.0f", (c.weather!.temperarure * (9/5) + 32)))"
                    apparentTemperature = "\(String(format: "%.0f", (c.weather!.apparentTemperature * (9/5) + 32)))"
                }
                summary = c.weather!.summary
                humidity = "\(c.weather!.humidity)"
                pressure = "\(c.weather!.pressure)"
                windSpeed = "\(c.weather!.windSpeed)"
                if !Locale.current.usesMetricSystem {
                    windSpeed = "\(c.weather!.windSpeed * (25/11))"
                }
                cloudCover = "\(c.weather!.cloudCover)"
            }
            
            newLine = "\(self.card.title),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),\(c.text),\(latitude),\(longitude),\(street), \(city), \(state), \(country), \(temperature), \(apparentTemperature), \(summary), \(humidity), \(pressure), \(windSpeed), \(cloudCover)\n"
            
            txtText.append(newLine)
        }
        do {
            try txtText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
        
        return path
    }
    private func setJson() -> URL? {
        let fileName = "\(self.card.title).json"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        let journalCard = self.card.data as! JournalCard
        let sortedValues = journalCard.values.sorted(byKeyPath: "created")
        
        var json = JSON()
        json["title"].string = self.card.title
        json["subtitle"].string = self.card.subtitle
        json["created"].double = self.card.created.timeIntervalSince1970
        if self.card.archived {
            json["archived"].double = self.card.archivedDate?.timeIntervalSince1970
        }
        
        for (i, c) in sortedValues.enumerated() {
            var valueJSON = JSON()
            valueJSON["created"].double = c.created.timeIntervalSince1970
            valueJSON["edited"].double = c.edited.timeIntervalSince1970
            valueJSON["latitude"].double = c.location?.latitude
            valueJSON["longitude"].double = c.location?.longitude
            valueJSON["street"].string = c.location?.street
            valueJSON["city"].string = c.location?.city
            valueJSON["state"].string = c.location?.state
            valueJSON["country"].string = c.location?.country
            valueJSON[WeatherKey.temperature].double = c.weather?.temperarure
            valueJSON[WeatherKey.apparentTemperature].double = c.weather?.apparentTemperature
            valueJSON[WeatherKey.summary].string = c.weather?.summary
            valueJSON[WeatherKey.humidity].double = c.weather?.humidity
            valueJSON[WeatherKey.pressure].double = c.weather?.pressure
            valueJSON[WeatherKey.windSpeed].double = c.weather?.windSpeed
            valueJSON[WeatherKey.cloudCover].double = c.weather?.cloudCover
            
            json["\(i)"] = valueJSON
        }
        do {
            try json.rawData().write(to: path!, options: Data.WritingOptions.atomicWrite)
        } catch {
            return nil
        }
        
        return path
    }
    
    @objc private func openMapAction(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.map.rawValue, bundle: nil).instantiateInitialViewController() as! MapViewController
        controller.card = self.card
        controller.navTitle = Localizations.Analytics.Journal.near
        if let nav = self.viewController?.parent as? UINavigationController {
            nav.pushViewController(controller, animated: true)
        }
    }
    
    @objc private func shareAction(sender: ASButtonNode) {
        guard let controller = self.viewController as? AnalyticsViewController else {
            return
        }
        
        let node = controller.collectionNode.nodeForItem(at: IndexPath(row: sender.view.tag, section: self.section))!
        
        var nodeImageViews = [UIImageView(image: node.view.snapshot)]
        if self.nodes[sender.view.tag] == .title {
            if let statNode = controller.collectionNode.nodeForItem(at: IndexPath(row: sender.view.tag + 1, section: self.section)) as? AnalyticsStatisticNode {
                nodeImageViews.append(UIImageView(image: statNode.view.snapshot))
            }
        }
        
        let imageBackgroundView = UIView()
        imageBackgroundView.backgroundColor = Themes.manager.analyticalStyle.background
        
        let stack = UIStackView(arrangedSubviews: nodeImageViews)
        stack.axis = .vertical
        
        imageBackgroundView.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(imageBackgroundView)
        imageBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        imageBackgroundView.layoutIfNeeded()
        let imageBackgroundViewImage = imageBackgroundView.snapshot!
        imageBackgroundView.removeFromSuperview()
        
        let sv = ShareView(image: imageBackgroundViewImage)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(sv)
        sv.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        sv.layoutIfNeeded()
        let im = sv.snapshot
        sv.removeFromSuperview()
        
        let shareContrroller = UIStoryboard(name: Storyboards.share.rawValue, bundle: nil).instantiateInitialViewController() as! ShareViewController
        shareContrroller.image = im
        shareContrroller.canonicalIdentifier = "journalShare"
        shareContrroller.channel = "Analytics"
        shareContrroller.shareHandler = { () in
            sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
        }
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
