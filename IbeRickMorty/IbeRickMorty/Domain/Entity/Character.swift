//
//  Character.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

struct Character: Identifiable, Equatable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let imageURL: String
}
