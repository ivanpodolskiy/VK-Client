//
//  GroupsFirebse.swift
//  LessonOne
//
//  Created by user on 18.11.2021.
//

import Foundation
import Firebase

class GroupsFirebse {
    var name: String
    let ref: DatabaseReference!
    init(name: String) {
        self.ref = nil
        self.name = name
    }
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let name = value["name"] as? String else {
                return nil
            }
        self.ref = snapshot.ref
        self.name = name
    }
    
    func toAnyObject() -> [String: Any] {
        return [ "name": name ]
    }
}
