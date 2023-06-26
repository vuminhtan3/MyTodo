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
    
    func clearAll() {
        standard.removeObject(forKey: Keys.kCompletedInputName.rawValue)
    }
    
}
