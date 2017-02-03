//
//  UserDefaultsApi.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 01/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation

class UserDefaultsApi {
    
    private struct UserDefaultsApiConstants {
        static let favoriteKey : String = "fav"
    }
    
    func getFavorites() -> [String] {
        return UserDefaults.standard.value(forKey: UserDefaultsApiConstants.favoriteKey) as? [String] ?? [String]()
    }
    
    func isFavorite(uniqueId id : String) -> Bool {
        if let favorites = UserDefaults.standard.value(forKey: UserDefaultsApiConstants.favoriteKey) as? [String] {
            if favorites.contains(id) {
                return true
            }
        }
        return false
    }
    
    func updateFavorite(uniqueId id : String) {
        var status : String = "nil"
        if let favorites = UserDefaults.standard.value(forKey: UserDefaultsApiConstants.favoriteKey) as? [String] {   
            var updatedFavorites = favorites
            if let position = self.getFavoritePosition(fromFavorites: updatedFavorites, uniqueId: id) {
                updatedFavorites.remove(at: position)
                status = "removed"
            } else {
                updatedFavorites.append(id)
                status = "added"
            }
            UserDefaults.standard.set(updatedFavorites, forKey: UserDefaultsApiConstants.favoriteKey)
        } else {
            let favorites : [String] = [id]
            UserDefaults.standard.set(favorites, forKey: UserDefaultsApiConstants.favoriteKey)
            status = "added (no previous record of userDefaults)"
        }
        UserDefaults.standard.synchronize()
        print("favorite \(id) \(status)")
    }
    
    private func getFavoritePosition(fromFavorites favorites : [String], uniqueId id : String) -> Int? {
        for i in 0..<favorites.count {
            if favorites[i] == id {
                return i
            }
        }
        return nil
    }
}
