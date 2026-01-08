//
//  IbeRickMortyApp.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import SwiftUI

@main
struct IbeRickMortyApp: App {
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                mainContentView
                
                if isLoading {
                    ZStack {
                        Color(.systemBackground).ignoresSafeArea()
                        LottieView(name: "loader")
                            .frame(width: 250, height: 250)
                    }
                    .transition(.opacity.animation(.easeOut(duration: 1.0)))
                    .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var mainContentView: some View {
        let cache = MemoryCache<String, [Character]>(ttl: 300)
        let apiClient = URLSessionAPIClient()
        let repository = CharacterRepositoryImpl(apiClient: apiClient, cache: cache)
        let useCase = SearchCharactersUseCase(repository: repository)
        
        SearchView(viewModel: SearchViewModel(useCase: useCase))
    }
}
