//
//  NetworkError.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
