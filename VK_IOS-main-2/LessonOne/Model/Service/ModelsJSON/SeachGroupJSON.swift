//
//  SeachGroupJSON.swift
//  LessonOne
//
//  Created by user on 25.10.2021.
//

import Foundation




// MARK: - SearchGropsJSON
struct SearchGropsJSON: Codable {
    let isMember, id: Int
    let photo100: String
    let isAdvertiser, isAdmin: Int
    let photo50, photo200: String
    let screenName, name: String
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

