//
//  EvaluateDayUITests.swift
//  EvaluateDayUITests
//
//  Created by Konstantin Tsistjakov on 09/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import XCTest
import SimulatorStatusMagic

class EvaluateDayUITests: XCTestCase {
    
    // MARK: - Variable
    var app: XCUIApplication!
    var ipad: Bool = false
    
    let en = "en-US"
    let ru = "ru"
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        SDStatusBarManager.sharedInstance().carrierName = "Evaluate Day"
        SDStatusBarManager.sharedInstance().timeString = "09:41"
        SDStatusBarManager.sharedInstance().bluetoothState = .hidden
        SDStatusBarManager.sharedInstance().batteryDetailEnabled = false
        SDStatusBarManager.sharedInstance().enableOverrides()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
            self.ipad = true
        }
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        SDStatusBarManager.sharedInstance().disableOverrides()
    }
    
    func testUI() {
        // Make screenshots for App Store
        let app = XCUIApplication()
        snapshot("01Evaluate")
        
        let tabBarsQuery = XCUIApplication().tabBars
        
        tabBarsQuery.buttons["activity"].tap()
        
        snapshot("02UsageStatistics")
        tabBarsQuery.buttons["evaluate"].tap()
        
        // Open analitycs
        app.collectionViews["evaluateCollection"].children(matching: .cell).element(boundBy: 1).buttons["analytics"].tap()
        snapshot("03CriterionAnalytics")
        XCUIApplication().navigationBars["evaluateNavigationBar"].children(matching: .button).element(boundBy: 0).tap()
        
        app.collectionViews["evaluateCollection"].swipeUp()
        app.collectionViews["evaluateCollection"].children(matching: .cell).element(boundBy: 0).buttons["analytics"].tap()
        snapshot("04ColorAnalytics")
        XCUIApplication().navigationBars["evaluateNavigationBar"].children(matching: .button).element(boundBy: 0).tap()
        
        XCUIApplication().navigationBars["evaluateNavigationBar"].buttons["newCardButton"].tap()
        snapshot("05Cards")
        XCUIApplication().tables["cardsTypeList"].children(matching: .cell).element(boundBy: 6).tap()
        snapshot("06CardSettings")
        
        XCUIApplication().navigationBars["evaluateNavigationBar"].children(matching: .button).element(boundBy: 0).tap()
        XCUIApplication().navigationBars["evaluateNavigationBar"].children(matching: .button).element(boundBy: 0).tap()
        XCUIApplication().navigationBars["evaluateNavigationBar"].buttons["reorderButton"].tap()
        snapshot("07Reorder")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
        
        tabBarsQuery.buttons["settings"].tap()
        snapshot("08Settings")
        
        XCUIApplication().tables["settingsTableView"].children(matching: .cell).element(boundBy: 3).tap()
        snapshot("09Themes")
    }
}
