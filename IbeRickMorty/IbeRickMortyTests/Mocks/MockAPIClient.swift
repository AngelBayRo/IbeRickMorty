//
//  MockAPIClient.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 9/1/26.
//

import Foundation
@testable import IbeRickMorty

final class MockAPIClient: APIClient {
    var callCount = 0
    var stubbedResponse: (() throws -> Any)?

    func request<T: Decodable>(_ url: URL) async throws -> T {
        callCount += 1

        guard let response = try stubbedResponse?() else {
            throw NetworkError.decodingError
        }

        if let typedResponse = response as? T {
            return typedResponse
        }

        throw NetworkError.decodingError
    }
}
