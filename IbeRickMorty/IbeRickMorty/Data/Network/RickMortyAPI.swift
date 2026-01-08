//
//  RickMortyAPI.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import Foundation

enum RickMortyAPI {
    static func searchCharacters(query: String) -> URL {
        URL(string: "https://rickandmortyapi.com/api/character/?name=\(query)")!
    }
}
