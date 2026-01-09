//
//  SearchViewModel.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var state: SearchState = .idle
    private let useCase: SearchCharactersUseCase
    private var searchTask: Task<Void, Never>?

    init(useCase: SearchCharactersUseCase) {
        self.useCase = useCase
    }

    func search(query: String) {
        searchTask?.cancel()

        searchTask = Task {
            state = .loading
            do {
                let result = try await useCase.execute(query: query)
                state = .success(result)
            } catch is CancellationError {
                // dont do nothing
            } catch {
                state = .error("¡Dimensión Desconocida!")
            }
        }
    }
}
