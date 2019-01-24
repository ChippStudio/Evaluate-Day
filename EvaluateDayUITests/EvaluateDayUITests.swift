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
        app.navigationBars["collectionNavigationBar"].buttons["hiddenButton"].tap()
//        app.collectionViews["collectionCollection"].buttons["AllCards"].tap()
//        XCUIApplication().navigationBars["evaluateNavigationBar"]/*@START_MENU_TOKEN@*/.buttons["newCardButton"]/*[[".buttons[\"Add new card\"]",".buttons[\"newCardButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
}
