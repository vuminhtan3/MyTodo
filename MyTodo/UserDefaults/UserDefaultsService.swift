//
//  UserDefaultsService.swift
//  MyTodo
//
//  Created by Minh Tan Vu on 23/06/2023.
//

import Foundation

class UserDefaultsService {
    static var shared = UserDefaultsService()
    private var standard = UserDefaults.standard
    
    private enum Keys: String {
        case kCompletedInputName
        case kOwner
    }
    private init() {
    }
    
    var completedInputName: Bool {

        get {
            return standard.bool(forKey: Keys.kCompletedInputName.rawValue)
        }
        set {
            standard.set(newValue, forKey: Keys.kCompletedInputName.rawValue)
            standard.synchronize()
        }
    }
    
    var owner: String {
        get {
            return standard.string(forKey: Keys.kOwner.rawValue)!
        }
        set {
            standard.set(newValue, forKey: Keys.kOwner.rawValue)
            standard.synchronize()
        }
    }
    
    func clearAll() {
        standard.removeObject(forKey: Keys.kCompletedInputName.rawValue)
        standard.removeObject(forKey: Keys.kOwner.rawValue)
    }
    
}
