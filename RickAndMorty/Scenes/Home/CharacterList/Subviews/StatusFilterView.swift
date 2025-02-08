//
//  StatusFilterView.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI

struct StatusFilterView: View {
    @Binding var selectedStatus: CharacterStatus?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CharacterStatus.allCases, id: \.self) { status in
                    FilterButton(
                        title: status.rawValue.capitalized,
                        isSelected: status == selectedStatus
                    ) {
                        selectedStatus = status
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 44)
        .background(Color(uiColor: .systemBackground))
    }
}
