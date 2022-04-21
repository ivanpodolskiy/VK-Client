//
//  FriendsModelOperation.swift
//  LessonOne
//
//  Created by user on 14.12.2021.
//

import Foundation
import RealmSwift
import Alamofire

// MARK: - Friends
struct FriendsList: Codable {
    let response: ResponseFriends
}

// MARK: - Response
struct ResponseFriends: Codable {
    let count: Int
    let items: [ItemFriends]
}

// MARK: - Item
class ItemFriends: Codable {
    
    let id: Int
    let lastName: String
    let photo50: String
    let trackCode, firstName: String
    let deactivated: String?

    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "last_name"
        case photo50 = "photo_50"
        case trackCode = "track_code"
        case firstName = "first_name"
        case deactivated
    }
}
