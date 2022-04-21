//
//  PhotoDB.swift
//  LessonOne
//
//  Created by user on 08.11.2021.
//

import Foundation
import RealmSwift

class PhotoDB {
    
    let migration = Realm.Configuration(schemaVersion: 5)


    func save(_ itme: [PhotoModel]){
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

    func load() -> Results<PhotoModel> {
        let realm = try! Realm(configuration: migration)
            let someModelResults: Results<PhotoModel> = realm.objects(PhotoModel.self)
//            let someModelArray: [PhotoModel] = someModelResults.toArray()
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
