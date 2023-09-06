//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  PaywallEventStore.swift
//
//  Created by Nacho Soto on 9/5/23.

import Foundation

protocol PaywallEventStoreType {

    /// Stores `event` into the store.
    func store(_ storedEvent: PaywallStoredEvent) async

    /// - Returns: the first `count` events from the store.
    func fetch(_ count: Int) async -> [PaywallStoredEvent]

    /// Removes the first `count` events from the store.
    func clear(_ count: Int) async

}

@available(iOS 15.0, tvOS 15.0, macOS 12.0, watchOS 8.0, *)
internal actor PaywallEventStore: PaywallEventStoreType {

    private let handler: FileHandlerType

    init(handler: FileHandlerType) {
        self.handler = handler
    }

    func store(_ storedEvent: PaywallStoredEvent) async {
        do {
            Logger.verbose(PaywallEventStoreStrings.storing_event(storedEvent.event))

            await self.handler.append(line: try PaywallEventSerializer.encode(storedEvent))
        } catch {
            Logger.error(PaywallEventStoreStrings.error_storing_event(error))
        }
    }

    func fetch(_ count: Int) async -> [PaywallStoredEvent] {
        assert(count > 0, "Invalid count: \(count)")

        do {
            return try await self.handler.readLines()
                .map { try PaywallEventSerializer.decode($0) }
                .prefix(count)
                .extractValues()
        } catch {
            Logger.error(PaywallEventStoreStrings.error_fetching_events(error))
            return []
        }
    }

    func clear(_ count: Int) async {
        assert(count > 0, "Invalid count: \(count)")

        do {
            try await self.handler.removeFirstLines(count)
        } catch {
            Logger.error(PaywallEventStoreStrings.error_removing_first_lines(count: count, error))

            // If removing these `count` events fails, try removing the entire file.
            // This ensures that we don't try to send the same events again.
            do {
                try await self.handler.emptyFile()
            } catch {
                Logger.error(PaywallEventStoreStrings.error_emptying_file(error))
            }
        }
    }

}

// MARK: - Messages

// swiftlint:disable identifier_name
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private enum PaywallEventStoreStrings {

    case storing_event(PaywallEvent)

    case error_storing_event(Error)
    case error_fetching_events(Error)
    case error_removing_first_lines(count: Int, Error)
    case error_emptying_file(Error)

}
// swiftlint:enable identifier_name

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension PaywallEventStoreStrings: LogMessage {

    var description: String {
        switch self {
        case let .storing_event(event):
            return "Storing event: \(event.debugDescription)"

        case let .error_storing_event(error):
            return "Error storing event: \((error as NSError).description)"

        case let .error_fetching_events(error):
            return "Error fetching events: \((error as NSError).description)"

        case let .error_removing_first_lines(count, error):
            return "Error removing first \(count) events: \((error as NSError).description)"

        case let .error_emptying_file(error):
            return "Error emptying file: \((error as NSError).description)"
        }
    }

    var category: String { return "paywall_event_store" }

}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension PaywallEvent {

    var debugDescription: String {
        return "\(self)"
    }

}
