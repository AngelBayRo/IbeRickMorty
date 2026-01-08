//
//  CharacterRowView.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            // 1. Imagen del personaje con AsyncImage
            AsyncImage(url: URL(string: character.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)

            // 2. Información textual
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    // Círculo indicador de estado
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    
                    Text("\(character.status) - \(character.species)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Flecha indicadora de navegación
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.vertical, 4)
    }
    
    // Lógica para el color del estado
    private var statusColor: Color {
        switch character.status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
}

#Preview("Character Row Layout") {
    Group {
        VStack(spacing: 20) {
            CharacterRowView(character: Character(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
            ))
            Divider()
            CharacterRowView(character: Character(
                id: 2,
                name: "Adolf Hitler",
                status: "Dead",
                species: "Human",
                imageURL: "https://rickandmortyapi.com/api/character/avatar/8.jpeg"
            ))
        }
        .padding()
    }
}
