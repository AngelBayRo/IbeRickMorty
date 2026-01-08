//
//  MemoryCache.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import Foundation

final class MemoryCache<Key: Hashable, T> {

    private struct Entry {
        let value: T
        let timestamp: Date
    }

    private let ttl: TimeInterval
    private var storage: [Key: Entry] = [:]

    init(ttl: TimeInterval = 180) {
        self.ttl = ttl
    }

    func get(_ key: Key) -> T? {
        guard let entry = storage[key] else { return nil }

        if Date().timeIntervalSince(entry.timestamp) < ttl {
            return entry.value
        }

        storage[key] = nil
        return nil
    }

    func set(_ value: T, for key: Key) {
        storage[key] = Entry(value: value, timestamp: Date())
    }
}
