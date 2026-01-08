//
//  CharacterDTO.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

struct CharacterResponseDTO: Decodable {
    let results: [CharacterDTO]
}

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let image: String

    func toDomain() -> Character {
        Character(
            id: id,
            name: name,
            status: status,
            species: species,
            imageURL: image
        )
    }
}
