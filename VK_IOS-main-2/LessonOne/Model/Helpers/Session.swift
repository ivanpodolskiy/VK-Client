//
//  Session.swift
//  LessonOne
//
//  Created by user on 16.10.2021.
//


import Foundation
import SwiftKeychainWrapper
class Session {
    private init() {}
    
    static let shared = Session()
   
    
    //UserDefaults
    var userId: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "UserId")
        } get {
            return UserDefaults.standard.integer(forKey: "UserId")
        }
    }
    
        //Keychain
    var token: String {
        set {
            KeychainWrapper.standard.set(newValue, forKey: "token")
            
        } get {
            KeychainWrapper.standard.string(forKey: "token") ?? ""
        }
    }
  
    
}
