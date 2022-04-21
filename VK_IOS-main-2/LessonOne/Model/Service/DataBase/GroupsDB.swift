//
//  GroupsDB.swift
//  LessonOne
//
//  Created by user on 08.11.2021.
//

import Foundation
import RealmSwift

class GropsDB {
    let migration = Realm.Configuration(schemaVersion: 1)

    func save(_ itme: [GroupsModel]){
        let realm = try! Realm(configuration: migration)
        do {
            realm.beginWrite()
            realm.add(itme)
            print(realm.configuration.fileURL ?? "Нет URL")
            try! realm.commitWrite()
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func load() -> Results<GroupsModel>{
        let realm = try! Realm(configuration: migration)
            let someModelResults: Results<GroupsModel> = realm.objects(GroupsModel.self)
//            let someModelArray: [GroupsModel] = someModelResults.toArray()
            return someModelResults
//        let friends: Results<FriendsModel> = realm.objects(FriendsModel.self)
    }
    
    func delete() {
        let realm = try! Realm(configuration: migration)
        try! realm.write {
          realm.deleteAll()
        }
    }
}
