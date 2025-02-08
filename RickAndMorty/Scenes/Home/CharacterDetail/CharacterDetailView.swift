//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack(spacing: 24) {
                VStack {
                    ZStack(alignment: .topLeading) {
                        characterImage()
                        backButton()
                    }
                }
                characterInfo()
                locationSection()
                Spacer()
            }
            .ignoresSafeArea(edges: .top)

        .background(Color(uiColor: .systemBackground))
        .navigationBarHidden(true)
    }
    
    private func characterImage() -> some View {
        // Character Image
        AsyncImage(url: URL(string: viewModel.character.image ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .containerRelativeFrame(.horizontal)
        } placeholder: {
            Color.gray.opacity(0.3)
                .aspectRatio(contentMode: .fit)
                .containerRelativeFrame(.horizontal)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private func backButton() -> some View {
        // Back button
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .frame(width: 32, height: 32)
                .background(Color.white)
                .clipShape(Circle())
        }
        .padding(.top, 48)
        .padding(.leading, 16)
    }
    
    private func characterInfo() -> some View {
        // Character Info
        VStack(spacing: 8) {
            HStack{
                VStack(alignment: .leading, spacing: 6){
                    Text(viewModel.character.name ?? "")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                         Text(viewModel.character.species ?? "")
                            .foregroundColor(.black.opacity(0.8))
                         Text("•")
                            .foregroundColor(.black.opacity(0.8))
                         Text(viewModel.character.gender?.rawValue ?? "")
                            .foregroundColor(.gray)
                     }
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 14))
                }
                Spacer()
                
                statusChip()
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func statusChip() -> some View {
        // Status Chip
        HStack(spacing: 6) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(viewModel.character.status?.rawValue.capitalized ?? "")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(uiColor: .systemBlue))
        .clipShape(Capsule())
        .padding(.top, 4)
    }
    
    private func locationSection() -> some View {
        // Location Section
        HStack {
            Text("Location: ")
                .font(.system(size: 16, weight: .semibold))
            Text(viewModel.character.location?.name ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var statusColor: Color {
        switch viewModel.character.status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown, .none:
            return .gray
        }
    }
}
