//
//  CharacterRepositoryImpl.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import Foundation

final class CharacterRepositoryImpl: CharacterRepository {

    private let apiClient: APIClient
    private let cache: MemoryCache<String, [Character]>

    init(apiClient: APIClient, cache: MemoryCache<String, [Character]>) {
        self.apiClient = apiClient
        self.cache = cache
    }

    func searchCharacters(query: String) async throws -> [Character] {
        let key = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !key.isEmpty else { return [] }

        if let cached = cache.get(key) {
            return cached
        }

        let url = RickMortyAPI.searchCharacters(query: key)
        let response: CharacterResponseDTO = try await apiClient.request(url)

        try Task.checkCancellation()

        let characters = response.results.map { $0.toDomain() }

        cache.set(characters, for: key)
        return characters
    }
}
