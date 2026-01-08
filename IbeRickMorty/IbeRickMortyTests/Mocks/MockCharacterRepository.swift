//
//  MockCharacterRepository.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 9/1/26.
//

@testable import IbeRickMorty

final class MockCharacterRepository: CharacterRepository {
    var result: [Character] = []
    var didCallSearch = false

    func searchCharacters(query: String) async throws -> [Character] {
        didCallSearch = true
        return result
    }
}
