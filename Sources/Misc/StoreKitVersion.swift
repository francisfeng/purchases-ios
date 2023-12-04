//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  StoreKitVersion.swift
//
//  Created by Mark Villacampa on 4/13/23.

import Foundation

/// Defines which version of StoreKit may be used
@objc(RCStoreKitVersion)
public enum StoreKitVersion: Int {

    /// Always use StoreKit 1. StoreKit 2 will be used (if available in the current device) only for certain APIs
    /// that provide a better implementation. For example: intro eligibility, determining if a receipt has
    /// purchases, managing subscriptions.
    case storeKit1

    /// Always use StoreKit 2.
    case storeKit2

    /// Let RevenueCat use the most appropiate version of StoreKit
    case `default`
}

extension StoreKitVersion {
    var versionString: String {
        switch self {
        case .storeKit1, .default:
            return "1"
        case .storeKit2:
            return "2"
        }
    }
}
