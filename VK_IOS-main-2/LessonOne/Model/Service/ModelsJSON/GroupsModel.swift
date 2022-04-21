//
//  GroupsModel.swift
//  LessonOne
//
//  Created by user on 25.10.2021.
//

import Foundation
import RealmSwift


// MARK: - Item
class GroupsModel: Object, Codable {
    @objc dynamic var isMember, id: Int
    @objc dynamic var photo100: String
    @objc dynamic var isAdvertiser, isAdmin: Int
    @objc dynamic var photo50, photo200: String
    @objc dynamic var screenName: String
    @objc dynamic var name: String
    let isClosed: Int

    enum CodingKeys: String, CodingKey {
        case isMember = "is_member"
        case id
        case photo100 = "photo_100"
        case isAdvertiser = "is_advertiser"
        case isAdmin = "is_admin"
        case photo50 = "photo_50"
        case photo200 = "photo_200"

        case screenName = "screen_name"
        case name
        case isClosed = "is_closed"
    }
}

