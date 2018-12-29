//
//  Store.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import StoreKit
import SwiftKeychainWrapper
import SwiftyJSON
import Alamofire

class Store: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
    
    // MARK: - Singleton
    static let current = Store()
    
    // MARK: - Variables
    var monthlyPrice: NSDecimalNumber = NSDecimalNumber(value: 0.0)
    var annuallyPrice: NSDecimalNumber = NSDecimalNumber(value: 0.0)
    var lifetimePrice: NSDecimalNumber = NSDecimalNumber(value: 0.0)
    var valid: Date?
    var locale: Locale = Locale.current
    
    // MARK: - Subscription information
    var expirationIntent: ExpirationIntent?
    var retryFlag: RetryFlag?
    var autoRenewStatus: AutoRenewStatus?
    var subscriptionID: String?
    
    // MARK: - Products
    var mouthly: SKProduct!
    var annualy: SKProduct!
    var lifetime: SKProduct!
    
    // MARK: - Pro
    var isPro: Bool {
        return Database.manager.application.user.pro
    }
    
    // MARK: - Private variable
    var monthlyProductID = "com.evaluateday.pro.month"
    var annuallyProductID = "com.evaluateday.pro.year"
    
    let lifetimeProductId = "com.evaluateday.pro.lifetime"
    
    // MARK: - Private handlers
    private var paymentHandler: ((SKPaymentTransaction?, Error?) -> Void)?
    private var restoreHandler: (([SKPaymentTransaction]?, Error?) -> Void)?
    
    // MARK: - Private init
    private override init() {
        super.init()
        
        if UserDefaults.standard.bool(forKey: "test") {
            self.monthlyProductID = "com.evaluateday.test.pro.month"
            self.annuallyProductID = "com.evaluateday.test.pro.year"
        }
    }
    
    // MARK: - SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            for p in response.products {
                if p.productIdentifier == self.monthlyProductID {
                    self.mouthly = p
                    self.monthlyPrice = p.price
                }
                if p.productIdentifier == self.annuallyProductID {
                    self.annualy = p
                    self.annuallyPrice = p.price
                }
                if p.productIdentifier == self.lifetimeProductId {
                    self.lifetime = p
                    self.lifetimePrice = p.price
                }
                
                self.locale = p.priceLocale
            }
        } else {
            print("WTF!! WTF!! WTF!!")
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        guard let transaction = transactions.first else {
            self.paymentHandler?(nil, StoreError.failPayment)
            return
        }
        
        switch transaction.transactionState {
        case .purchasing: ()
        case .purchased:
            self.validateReceipt(completion: { (isPro, date) in
                self.valid = date
                try! Database.manager.app.write {
                    Database.manager.application.user.pro = isPro
                }
                
                if isPro {
                    self.paymentHandler?(transactions.first, nil)
                } else {
                    self.paymentHandler?(nil, ReceiptValidateError.fail)
                }
            })
        case .failed:
            self.paymentHandler?(nil, transaction.error)
            if transaction.error != nil {
                print(transaction.error!.localizedDescription)
            }
        case .restored:
            self.validateReceipt(completion: { (isPro, date) in
                self.valid = date
                try! Database.manager.app.write {
                    Database.manager.application.user.pro = isPro
                }
                
                if isPro {
                    self.restoreHandler?(transactions, nil)
                } else {
                    self.restoreHandler?(nil, ReceiptValidateError.fail)
                }
            })
        case .deferred: ()
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if queue.transactions.isEmpty {
            self.restoreHandler?(nil, StoreError.failRestore)
        } else {
            self.validateReceipt(completion: { (isPro, date) in
                self.valid = date
                try! Database.manager.app.write {
                    Database.manager.application.user.pro = isPro
                }
                
                if isPro {
                    self.restoreHandler?(queue.transactions, nil)
                } else {
                    self.restoreHandler?(nil, ReceiptValidateError.fail)
                }
            })
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        self.restoreHandler?(nil, error)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        
        self.isNeedOpenDetails = true
        self.openDetailsController()
        
        if self.isPro {
            return false
        }
        
        return true
    }
    
    // MARK: - SKRequestDelegate
    func requestDidFinish(_ request: SKRequest) {
//        self.validateReceipt()
//        print("Where WTF!!")
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print(" TRANSACTION ERROR = \(error.localizedDescription)")
    }
    
    // MARK: - Computed variables
    var localizedAnnualyPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = self.locale
        
        if let number = numberFormatter.string(from: self.annuallyPrice) {
            return number
        }
        
        return "😇"
    }
    
    var localizedMonthlyPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = self.locale
        
        if let number = numberFormatter.string(from: self.monthlyPrice) {
            return number
        }
        
        return "😇"
    }
    
    var localizedLifetimePrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = self.locale
        
        if let numder = numberFormatter.string(from: self.lifetimePrice) {
            return numder
        }
        
        return "😇"
    }
    
    // MARK: - Actions
    private var isNeedOpenDetails = false
    func openDetailsController() {
        if !self.isNeedOpenDetails {
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController is PasscodeViewController {
                return
            }
            
            let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            let nav = UINavigationController(rootViewController: controller)
            topController.present(nav, animated: true, completion: nil)
        }
        
        self.isNeedOpenDetails = false
        
    }
    func activate() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: [self.monthlyProductID, self.annuallyProductID, self.lifetimeProductId])
            request.delegate = self
            request.start()
        }
        SKPaymentQueue.default().add(self)
        self.recontrolPro()
    }
    
    /// Recontrol is the current user is pro
    func recontrolPro() {
        if let d = self.valid {
            if d > Date() {
                return
            }
        }
        
        self.validateReceipt(completion: { (isPro, date) in
            self.valid = date
            try! Database.manager.app.write {
                Database.manager.application.user.pro = isPro
            }
            
            if isPro {
                // Clear pro version from keychain
                KeychainWrapper.standard.removeObject(forKey: keychainProDuration)
                KeychainWrapper.standard.removeObject(forKey: keychainProStart)
            } else {
                self.controlFromPreviousVersion { (isPro, date) in
                    self.valid = date
                    try! Database.manager.app.write {
                        Database.manager.application.user.pro = isPro
                    }
                    
                    if !isPro {
                        // Clear pro version
                        KeychainWrapper.standard.removeObject(forKey: keychainProDuration)
                        KeychainWrapper.standard.removeObject(forKey: keychainProStart)
                    }
                }
            }
        })
    }
    
    func payment(product: SKProduct!, completion: @escaping (SKPaymentTransaction?, Error?) -> Void) {
        guard let product = product else {
            completion(nil, StoreError.noProduct)
            return
        }
        self.paymentHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore(completion: @escaping ([SKPaymentTransaction]?, Error?) -> Void) {
        self.restoreHandler = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Private actions
    /// Control Pro from previous version
    private func controlFromPreviousVersion(completion: (_ isPro: Bool, _ date: Date?) -> Void) {
        if UserDefaults.standard.bool(forKey: "demo") || UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            var dateComponents = DateComponents()
            dateComponents.month = 24
            let validDate = Calendar.current.date(byAdding: dateComponents, to: Date())
            completion(true, validDate)
            return
        }
        if let proDate = KeychainWrapper.standard.integer(forKey: keychainProStart) {
            if let proDuration = KeychainWrapper.standard.integer(forKey: keychainProDuration) {
                let proStartDate = Date(timeIntervalSince1970: TimeInterval(proDate))
                var dateComponents = DateComponents()
                dateComponents.month = proDuration
                
                if let validDate = Calendar.current.date(byAdding: dateComponents, to: proStartDate) {
                    if validDate > Date() {
                        completion(true, validDate)
                    } else {
                        completion(false, nil)
                    }
                }
            } else {
                completion(false, nil)
            }
        } else {
            completion(false, nil)
        }
    }
    
    /// Validate receipt
    private func validateReceipt(completion: @escaping (_ isPro: Bool, _ date: Date?) -> Void) {
        guard let url = Bundle.main.appStoreReceiptURL else {
            completion(false, nil)
            return
        }
        
        do {
            let receiptData = try Data(contentsOf: url)
            var params = [String: Any]()
            params["receipt-data"] = receiptData.base64EncodedString(options: [])
            params["password"] = itunesSecret
            
            var receiptValidationURL = "https://buy.itunes.apple.com/verifyReceipt"
            if Bundle.main.object(forInfoDictionaryKey: "CSSandbox") as! Bool {
                receiptValidationURL = "https://sandbox.itunes.apple.com/verifyReceipt"
            }
            Alamofire.request(receiptValidationURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { (response) in
                if response.result.error != nil {
                    sendEvent(.recieptValidationError, withProperties: ["message": response.result.error!.localizedDescription])
//                    print("VALIDATION ERROR - \(response.result.error!.localizedDescription)")
                    return
                }
                
                let json = JSON(response.result.value!)
//                print("RECEIPTE JSON STATUS = \(json["status"].intValue)")
                if json["status"].intValue != 0 {
                    completion(false, nil)
                    return
                }
                
                var isPro = false
                var validDate: Date?
                var trial = false
                var lifetime = false
                
                for (_, receipt) in json["latest_receipt_info"] {
                    if receipt["product_id"].stringValue == self.lifetimeProductId {
                        isPro = true
                        lifetime = true
                        break
                    }
                    let date = Date(timeIntervalSince1970: receipt["expires_date_ms"].doubleValue / 1000)
                    if date > Date() {
                        isPro = true
                        validDate = date
                        
                        if receipt["is_trial_period"].stringValue == "true" {
                            trial = true
                        }
                        self.subscriptionID = receipt["product_id"].string
                    }
                }
                
                // Subscription status information
                for (_, info) in json["pending_renewal_info"] {
                    if let intent = info["expiration_intent"].string {
                        self.expirationIntent = ExpirationIntent(rawValue: intent)
                    }
                    if let retry = info["is_in_billing_retry_period"].string {
                        self.retryFlag = RetryFlag(rawValue: retry)
                    }
                    if let status = info["auto_renew_status"].string {
                        self.autoRenewStatus = AutoRenewStatus(rawValue: status)
                    }
                }
                
                // Log analytics events
                if Date(timeIntervalSince1970: UserDefaults.standard.object(forKey: "sendAnaliticsPurchaceDate") as! Double) < Date() {
                    // New purchase transaction
                    purchase(item: self.subscriptionID, trial: trial, lifetime: lifetime, receipt: receiptData)
                    if self.valid != nil {
                        UserDefaults.standard.set(self.valid!.timeIntervalSince1970, forKey: "sendAnaliticsPurchaceDate")
                    }
                }
                
                if self.autoRenewStatus == AutoRenewStatus.turnedOff {
                    //Future transaction stopped
                    if UserDefaults.standard.bool(forKey: "logPurchaseTurnOffReason") {
                        if self.expirationIntent != nil && self.retryFlag != nil {
                            sendEvent(.proTurnedOff, withProperties: ["intent": self.expirationIntent!.localizedDescription, "retry": self.retryFlag!.localizedDescription])
                            UserDefaults.standard.set(false, forKey: "logPurchaseTurnOffReason")
                        }
                    }
                }
                
                completion(isPro, validDate)
                
            })
        } catch {
            completion(false, nil)
        }
    }
}
