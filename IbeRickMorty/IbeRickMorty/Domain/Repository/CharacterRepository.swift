//
//  CharacterRepository.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

protocol CharacterRepository {
    func searchCharacters(query: String) async throws -> [Character]
}
