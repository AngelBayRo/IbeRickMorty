//
//  SearchCharactersUseCase.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import Foundation

final class SearchCharactersUseCase {
    private let repository: CharacterRepository

    init(repository: CharacterRepository) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [Character] {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return [] }

        try Task.checkCancellation()
        return try await repository.searchCharacters(query: normalized)
    }
}
