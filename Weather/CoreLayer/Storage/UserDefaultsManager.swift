//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Rotach Roman on 06.10.2023.
//

import Foundation

struct UserDefaultsManager {
    
    enum Keys: String {
        case chooseCity
    }
    
    private static let defaults = UserDefaults.standard
    
    static func remove(key: Keys) {
        self.defaults.removeObject(forKey: key.rawValue)
    }
}

extension UserDefaultsManager {
    
    static var choosenCity: String? {
        get {
            return defaults.string(forKey: Keys.chooseCity.rawValue)
        }
        
        set {
            defaults.set(newValue, forKey: Keys.chooseCity.rawValue)
        }
    }
}
