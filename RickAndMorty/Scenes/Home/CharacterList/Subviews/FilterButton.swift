//
//  FilterButton.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(uiColor: .systemGray2) : Color(uiColor: .systemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black.opacity(0.2), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}
