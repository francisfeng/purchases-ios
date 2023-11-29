//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  SK2AppTransaction.swift
//
//  Created by MarkVillacampa on 26/10/23.

import StoreKit

/// A wrapper for `StoreKit.AppTransaction`.
internal struct SK2AppTransaction {

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    init(appTransaction: AppTransaction) {
        self.bundleId = appTransaction.bundleID
        self.originalApplicationVersion = appTransaction.originalAppVersion
        self.originalPurchaseDate = appTransaction.originalPurchaseDate
        self.environment = .init(environment: appTransaction.environment)
    }

    init(
        bundleID: String,
        originalApplicationVersion: String?,
        originalPurchaseDate: Date?,
        environment: StoreEnvironment?
    ) {
        self.bundleId = bundleID
        self.originalApplicationVersion = originalApplicationVersion
        self.originalPurchaseDate = originalPurchaseDate
        self.environment = environment
    }

    let bundleId: String
    let originalApplicationVersion: String?
    let originalPurchaseDate: Date?
    let environment: StoreEnvironment?

}
