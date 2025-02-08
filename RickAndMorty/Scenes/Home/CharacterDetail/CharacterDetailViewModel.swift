//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI

final class CharacterDetailViewModel: ObservableObject {
    let character: CharacterModel
    
    init(character: CharacterModel) {
        self.character = character
    }
}
