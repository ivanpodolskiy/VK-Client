//
//  PhotoModel.swift
//  LessonOne
//
//  Created by user on 25.10.2021.
//

import Foundation
import RealmSwift


class PhotoModel: Object, Codable {
    var albumID: Int = 0
    var  postID = 0
    var id = 0
    var date: Int = 0
    var text: String = ""
    var realOffset: Int = 0
    var sizes = List<SizePhoto>()
    var hasTags: Bool = true
    var ownerID: Int = 0

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case postID = "post_id"
        case id, date, text
        case realOffset = "real_offset"
        case sizes
//        case hasTags = "has_tags"
        case ownerID = "owner_id"
    }
}




// MARK: - Size
class SizePhoto:  Object, Codable {
    var width = 0, height: Int = 0
    @objc dynamic var  url: String = ""
    var type: String = ""
//    let walkers = LinkingObjects(fromType: Size.self, property:"sizes")
}
//
//class PhotoModel: Object, Codable {
//
//    var albumID: Int
//    @objc dynamic var  postID, id, date: Int
//    let text: String
//    let realOffset: Int
//
//    var sizes = List<Size>
//    let hasTags: Bool
//
//    let ownerID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case albumID = "album_id"
//        case postID = "post_id"
//        case id, date, text
//        case realOffset = "real_offset"
//        case sizes
//        case hasTags = "has_tags"
//        case ownerID = "owner_id"
//
//    }
//}

//// MARK: - Size
//struct Size:   Codable {
//    let width, height: Int
//    @objc dynamic var  url: String
//    let type: String
//}
//
