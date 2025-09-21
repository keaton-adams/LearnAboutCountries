//
//  FavoritesStore.swift
//  LAC
//
//  Created by Keaton Adams on 9/20/25.
//

import Foundation

final class FavoritesStore {
    static let shared = FavoritesStore()
    private let key = "favoriteCountries"
    private let defaults: UserDefaults
    private var favorites: Set<String> = []
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let currentFavoritse = defaults.array(forKey: key) as? [String] {
            favorites = Set(currentFavoritse)
        }
    }
    
    func isFavorite(code: String) -> Bool {
        favorites.contains(code)
    }
    
    func toggle(code: String) -> Bool {
        if favorites.contains(code) {
            favorites.remove(code)
        } else {
            favorites.insert(code)
        }
        defaults.set(Array(favorites), forKey: key)
        return favorites.contains(code)
    }
}
