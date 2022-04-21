//
//  FriendsModel.swift
//  LessonOne
//
//  Created by user on 25.10.2021.
//

//Это для realm
import Foundation
import RealmSwift

//test
struct FriendsJSON: Codable {
    let response: FriendsResponse
}

//test
struct FriendsResponse: Codable {
    let count: Int
    let items: [FriendsModel]
}

class FriendsModel: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var firstName: String = ""
    
    var fullName: String {
        return (firstName) + " " + (lastName)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "last_name"
        case photo50 = "photo_50"
        case firstName = "first_name"
    }
}
