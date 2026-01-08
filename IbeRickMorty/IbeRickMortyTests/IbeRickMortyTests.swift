//
//  IbeRickMortyTests.swift
//  IbeRickMortyTests
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import Testing
import Foundation
@testable import IbeRickMorty
internal import Combine

@MainActor
struct IbeRickMortyTests {
    // MARK: - ViewModel Tests
    @Test func testSearchUpdatesState() async throws {
        let repo = MockCharacterRepository()
        repo.result = [Character(id: 1, name: "Morty", status: "Alive", species: "Human", imageURL: "")]
        let vm = SearchViewModel(useCase: SearchCharactersUseCase(repository: repo))

        vm.search(query: "Morty")

        await confirmation("El estado cambia a success", expectedCount: 1) { done in
            for await state in vm.$state.values {
                if case .success(let result) = state {
                    #expect(result.count == 1)
                    #expect(result.first?.name == "Morty")
                    done()
                    break
                }
            }
        }
    }

    // MARK: - UseCase Tests
    @Test func testSearchCharactersReturnsData() async throws {
        let repo = MockCharacterRepository()
        repo.result = [Character(id: 1, name: "Rick", status: "Alive", species: "Human", imageURL: "")]
        let useCase = SearchCharactersUseCase(repository: repo)

        let result = try await useCase.execute(query: "Rick")

        #expect(result.count == 1)
        #expect(result.first?.name == "Rick")
    }

    // MARK: - Cache Tests
    @Test func testCacheExpiration() async throws {
        let cache = MemoryCache<String, Int>(ttl: 0.1) // para que el test sea rápido
        cache.set(10, for: "key")

        #expect(cache.get("key") == 10)

        try await Task.sleep(for: .seconds(0.2))
        
        #expect(cache.get("key") == nil)
    }
    
    @Test func testRepositoryUsesCacheAndSkipsNetwork() async throws {
        let mockAPI = MockAPIClient()
        let cache = MemoryCache<String, [Character]>(ttl: 300)
        let repo = CharacterRepositoryImpl(apiClient: mockAPI, cache: cache)
        
        let character = Character(id: 1, name: "Rick", status: "Alive", species: "Human", imageURL: "")

        cache.set([character], for: "rick")

        let result = try await repo.searchCharacters(query: "Rick")
        
        #expect(result.count == 1)
        #expect(mockAPI.callCount == 0)
    }

    // MARK: - Requisito: CONCURRENCIA (Presentation Layer)
    @Test func testSearchCancellationOnNewQuery() async throws {
        let repo = MockCharacterRepository()
        repo.result = [Character(id: 1, name: "Rick", status: "Alive", species: "Human", imageURL: "")]
        
        let useCase = SearchCharactersUseCase(repository: repo)
        let vm = SearchViewModel(useCase: useCase)

        vm.search(query: "R")
        vm.search(query: "Ri")
        vm.search(query: "Rick")

        try await Task.sleep(for: .seconds(0.2))
        
        if case .success(let characters) = vm.state {
            #expect(characters.first?.name == "Rick")
        } else {
            Issue.record("El estado final debería ser .success")
        }
    }
        
    // MARK: - Requisito: EXPIRACIÓN
    @Test func testCacheRefreshesFromNetworkAfterExpiration() async throws {
        let mockAPI = MockAPIClient()
        let cache = MemoryCache<String, [Character]>(ttl: 0.1)
        let repo = CharacterRepositoryImpl(apiClient: mockAPI, cache: cache)
        
        cache.set([], for: "rick")
        try await Task.sleep(for: .seconds(0.2))
        
        mockAPI.stubbedResponse = {
            CharacterResponseDTO(results: [
                CharacterDTO(id: 1, name: "Rick", status: "Alive", species: "Human", image: "")
            ])
        }
        
        _ = try await repo.searchCharacters(query: "Rick")
        #expect(mockAPI.callCount == 1)
    }
}
