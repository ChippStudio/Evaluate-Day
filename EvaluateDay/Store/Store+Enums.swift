//
//  Store+Enums.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation

// MARK: - App Store
/// Subscription Expiration Intent
/// @key - expiration_intent
enum ExpirationIntent: String {
    case customerCanceled = "1"
    case billingError = "2"
    case priceIncrease = "3"
    case productNotAvaible = "4"
    case unknownError = "5"
    
    var localizedDescription: String {
        switch self {
        case .customerCanceled:
            return "Customer canceled their subscription."
        case .billingError:
            return "Billing error; for example customer’s payment information was no longer valid."
        case .priceIncrease:
            return "Customer did not agree to a recent price increase."
        case .productNotAvaible:
            return "Product was not available for purchase at the time of renewal."
        case .unknownError:
            return "Unknown error."
        }
    }
}

///Subscription Retry Flag
///@key - is_in_billing_retry_period
enum RetryFlag: String {
    case still = "1"
    case stopped = "0"
    
    var localizedDescription: String {
        switch self {
        case .still:
            return "App Store is still attempting to renew the subscription."
        case .stopped:
            return "App Store has stopped attempting to renew the subscription."
        }
    }
}

/// Subscription Auto Renew Status
/// @key - auto_renew_status
enum AutoRenewStatus: String {
    case renew = "1"
    case turnedOff = "0"
    
    var localizedDescription: String {
        switch self {
        case .renew:
            return "Subscription will renew at the end of the current subscription period."
        case .turnedOff:
            return "Customer has turned off automatic renewal for their subscription."
        }
    }
}
// MARK: - Errors
enum StoreError: Error {
    case noProduct
    case failPayment
    case failRestore
    
    var localizedDescription: String {
        get {
            switch self {
            case .noProduct:
                return "No valid product"
            case .failPayment:
                return "Fail payment"
            case .failRestore:
                return "Fail restore"
            }
        }
    }
}

enum ReceiptValidateError: Error {
    case fail
    
    var localizedDescription: String {
        get {
            switch self {
            case .fail:
                return "Fail receipt validation"
            }
        }
    }
}
