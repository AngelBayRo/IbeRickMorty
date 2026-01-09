//
//  SearchView.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State private var query = ""
    @State private var isRotating = 0.0

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Rick & Morty")
        }
        .searchable(text: $query, placement: .automatic, prompt: "Busca a Rick, Morty...")
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .onChange(of: query) { _, newQuery in
            viewModel.search(query: newQuery)
        }
    }

    private var content: some View {
        Group {
            switch viewModel.state {
            case .idle:
                placeholderView(
                    imageName: "portal",
                    title: "¡Wubba Lubba Dub Dub!",
                    subtitle: "Busca un personaje para abrir el portal"
                )
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                    Spacer()
                }
            case .success(let characters):
                if characters.isEmpty {
                    placeholderView(
                        imageName: "portal",
                        title: "¡Wubba Lubba Dub Dub!",
                        subtitle: "Busca un personaje para abrir el portal"
                    )
                } else {
                    List(characters) { character in
                        NavigationLink {
                            CharacterDetailView(character: character)
                        } label: {
                            CharacterRowView(character: character)
                        }
                    }
                    .listStyle(.plain)
                }
            case .error(let message):
                placeholderView(
                    imageName: "jerry",
                    title: message,
                    subtitle: "Parece que '\(query)' no existe en esta realidad"
                )
            }
        }
    }

    private func placeholderView(imageName: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .rotationEffect(.degrees(imageName == "portal" ? isRotating : 0))
                .shadow(color: .green.opacity(imageName == "portal" ? 0.4 : 0), radius: 20)
                .onAppear {
                    if imageName == "portal" {
                        withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                            isRotating = 360
                        }
                    }
                }
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let dummyCharacters = [
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        ),
        Character(
            id: 2,
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            imageURL: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
        )
    ]

    let mockRepository = MockCharacterRepositoryPreview(result: dummyCharacters)
    let useCase = SearchCharactersUseCase(repository: mockRepository)
    let viewModel = SearchViewModel(useCase: useCase)

    viewModel.state = .success(dummyCharacters)

    return SearchView(viewModel: viewModel)
}

final class MockCharacterRepositoryPreview: CharacterRepository {

    private let result: [Character]

    init(result: [Character]) {
        self.result = result
    }

    func searchCharacters(query: String) async throws -> [Character] {
        result
    }
}
