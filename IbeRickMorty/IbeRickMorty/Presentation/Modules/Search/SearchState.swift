//
//  SearchState.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

enum SearchState {
    case idle
    case loading
    case success([Character])
    case error(String)
}
