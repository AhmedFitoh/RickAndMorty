//
//  CharacterRowView.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI

struct CharacterRowView: View {
    let character: CharacterModel
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: character.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 6)
                
                Text(character.species ?? "")
                    .font(.system(size: 14))
                Spacer()
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(index % 2 == 0 ? Color.white : Color(uiColor: .systemGray6))
                .stroke(.black.opacity(0.05))
        )

        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
