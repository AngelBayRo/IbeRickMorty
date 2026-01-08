//
//  CharacterDetailView.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerImage
                    .padding(.top, 96)
                detailsCard
                    .offset(y: -60)
                    .padding(.horizontal)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemGroupedBackground))
    }
    
    private var headerImage: some View {
        AsyncImage(url: URL(string: character.imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle().fill(Color.gray.opacity(0.3))
        }
        .frame(height: 400)
        .mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: 0.2),
                    .init(color: .black, location: 0.8),
                    .init(color: .clear, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Detail")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .textCase(.uppercase)
                
                HStack(alignment: .firstTextBaseline) {
                    Text(character.name)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Text("#\(character.id)")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.gray.opacity(0.55))
                }
            }
            Divider()
            VStack(spacing: 16) {
                InfoRow(label: "Status", value: character.status, color: statusColor)
                InfoRow(label: "Species", value: character.species)
            }
        }
        .padding(25)
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
    
    private var statusColor: Color {
        character.status.lowercased() == "alive" ? .green : .red
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var color: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .font(.callout)
    }
}

#Preview {
    CharacterDetailView(
        character: Character(id: 2,
                             name: "Morty",
                             status: "Alive",
                             species: "Human",
                             imageURL: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"))
}
