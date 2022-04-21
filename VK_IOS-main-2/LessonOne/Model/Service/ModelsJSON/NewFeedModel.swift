//
//  NewFeedModel.swift
//  LessonOne
//  Created by user on 19.11.2021.

import Foundation

// MARK: - NewJSON
struct NewJSON: Codable {
    var response: Response
}

// MARK: - Response
struct Response: Codable {
    var items: [Item]
    var groups: [NewGroup]
    var profiles: [Profile]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items, groups, profiles
        case nextFrom = "next_from"
    }
    
//    init(items: [Item], gruops: [NewGroup], profiles: [Profile]) {
//        self.items = items
//        self.groups = gruops
//        self.profiles = profiles
//    }
}

// MARK: - Group
struct NewGroup: Codable {
    let isMember: Int?
    let id: Int
    let photo100: String
    let isAdvertiser: Int?
    let isAdmin: Int?
    let photo50, photo200: String
    let type, screenName, name: String
    let isClosed: Int

    enum CodingKeys: String, CodingKey {
        case isMember = "is_member"
        case id
        case photo100 = "photo_100"
        case isAdvertiser = "is_advertiser"
        case isAdmin = "is_admin"
        case photo50 = "photo_50"
        case photo200 = "photo_200"
        case type
        case screenName = "screen_name"
        case name
        case isClosed = "is_closed"
    }
}

// MARK: - Item
struct Item: Codable {
    let comments: Comments?
    let canSetCategory: Bool?
    let topicID: Int?
    let likes: Likes?
    let reposts: Reposts?
    let type: String
    let postType: String?
    let date, sourceID: Int
    let text: String?
    let canDoubtCategory: Bool?
    let attachments: [Attachment]
    let markedAsAds: Int?
    let postID: Int
    let postSource: PostSource
    let views: Views

    enum CodingKeys: String, CodingKey {
        case comments
        case canSetCategory = "can_set_category"
        case topicID = "topic_id"
        case likes, reposts, type
        case postType = "post_type"
        case date
        case sourceID = "source_id"
        case text
        case canDoubtCategory = "can_doubt_category"
        case attachments
        case markedAsAds = "marked_as_ads"
        case postID = "post_id"
        case postSource = "post_source"
        case views
    }
    var hasText: Bool {
        return self.text != nil && self.text != ""
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: String
    let photo: Photo?
    let video: Video?
}

// MARK: - Photo
struct Photo: Codable {
    let albumID, id, date: Int
    let text: String
    let userID: Int?
    let sizes: [Size]?
    let ownerID: Int
    let accessKey: String
    
    var photoNum: Size? {
        guard let sizes = self.sizes else { return nil }
               if let photo = sizes.first(where: {$0.type == "x"}) { return photo }
               if let photo = sizes.first(where: {$0.type == "z"}) { return photo }
               if let photo = sizes.first(where: {$0.type == "y"}) { return photo }
               if let photo = sizes.first(where: {$0.type == "m"}) { return photo }
               if let photo = sizes.first(where: {$0.type == "s"}) { return photo }
               return sizes.first
    }

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case id, date, text
        case userID = "user_id"
        case sizes
        case ownerID = "owner_id"
        case accessKey = "access_key"
    }
}

struct Video: Codable {
    let firstFrame800: String?
    let ownerID, canAdd, duration: Int
    let photo320, photo1280, firstFrame1280: String?
    let title: String
    let videoRepeat: Int?
    let views, canLike, canComment: Int
    let firstFrame130: String
    let date: Int
    let firstFrame160: String?
    let id, height: Int
    let trackCode: String
    let width, canAddToFaves: Int
    let accessKey: String
    let photo800, photo130: String
    let canSubscribe: Int
    let firstFrame320: String
    let canRepost: Int
    let videoDescription: String

    enum CodingKeys: String, CodingKey {
        case firstFrame800 = "first_frame_800"
        case ownerID = "owner_id"
        case canAdd = "can_add"
        case duration
        case photo320 = "photo_320"
        case photo1280 = "photo_1280"
        case firstFrame1280 = "first_frame_1280"
        case title, views
        case videoRepeat = "repeat"
        case canLike = "can_like"
        case canComment = "can_comment"
        case firstFrame130 = "first_frame_130"
        case date
        case firstFrame160 = "first_frame_160"
        case id, height
        case trackCode = "track_code"
        case width
        case canAddToFaves = "can_add_to_faves"
        case accessKey = "access_key"
        case photo800 = "photo_800"
        case photo130 = "photo_130"
        case canSubscribe = "can_subscribe"
        case firstFrame320 = "first_frame_320"
        case canRepost = "can_repost"
        case videoDescription = "description"
    }
}

// MARK: - Size
struct Size: Codable {
    let width, height: Int
    let url: String
    let type: String
}

// MARK: - Comments
struct Comments: Codable {
    let count, canPost: Int
    let groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

// MARK: - Likes
struct Likes: Codable {
    let canLike, canPublish, count, userLikes: Int

    enum CodingKeys: String, CodingKey {
        case canLike = "can_like"
        case canPublish = "can_publish"
        case count
        case userLikes = "user_likes"
    }
}

// MARK: - PostSource
struct PostSource: Codable {
    let platform, type: String?
}

// MARK: - Reposts
struct Reposts: Codable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Views
struct Views: Codable {
    let count: Int
}

// MARK: - Profile
struct Profile: Codable {
    let online, id: Int
    let photo100: String
    let lastName: String
    let photo50: String
    let onlineInfo: OnlineInfo
    let sex: Int
    let screenName: String?
    let firstName: String

    enum CodingKeys: String, CodingKey {
        case online, id
        case photo100 = "photo_100"
        case lastName = "last_name"
        case photo50 = "photo_50"
        case onlineInfo = "online_info"
        case sex
        case screenName = "screen_name"
        case firstName = "first_name"
    }
}

// MARK: - OnlineInfo
struct OnlineInfo: Codable {
    let visible, isMobile, isOnline: Bool

    enum CodingKeys: String, CodingKey {
        case visible
        case isMobile = "is_mobile"
        case isOnline = "is_online"
    }
}



