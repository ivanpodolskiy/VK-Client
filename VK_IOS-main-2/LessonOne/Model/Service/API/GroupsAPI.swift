//
//  GroupsAPI.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit
import UIKit




enum ApplicationError: Error {
    case noGroups
}

final class GroupsAPI  {
    let baseUrl = "https://api.vk.com/method"
    let token = Session.shared.token
    let userId = Session.shared.userId
    let version = "5.81"
    
    func promiseGetGroup() -> Promise<[GroupsModel]> {
        return Promise<[GroupsModel]> { resolver in
            
            let method = "/groups.get"
            let parametrs: Parameters = [
                "user-id": userId,
                "access_token": token,
                "user_id": userId,
                "count": 1000,
                "v": version,
                "extended": 1]
            
            let url = baseUrl + method
            AF.request(url, method: .get, parameters: parametrs).responseJSON { response in
                if let error = response.error {
                    resolver.reject(error)
                }
                guard let data = response.data else {return}
                
                do {
                    let groupJSON = try JSON(data)["response"]["items"].rawData()
                    let groups = try JSONDecoder().decode([GroupsModel].self, from: groupJSON)
                    resolver.fulfill(groups)
                } catch {
                    print (error)
                }
            }
        }
    }
    
    
    
    //OLD
    func getGroups(completion: @escaping([GroupsModel]) -> ()) {
        
        
        let method = "/groups.get"
        let parametrs: Parameters = [
            "user-id": userId,
            "access_token": token,
            "user_id": userId,
            "count": 1000,
            "v": version,
            //            "fields": "city",
            "extended": 1
            
        ]
        
        let url = baseUrl + method
        AF.request(url, method: .get, parameters: parametrs).responseJSON { response in
            
            guard let data = response.data else {return}
//            debugPrint(response.data?.prettyJSON)
            
            do {
                let groupJSON = try JSON(data)["response"]["items"].rawData()
                let groups = try JSONDecoder().decode([GroupsModel].self, from: groupJSON)
                
                completion(groups)
            } catch {
                print (error)
            }
        }
    }
}

//protocol GroupServiceInterface {
//    func getGroups(completion: @escaping([GroupsModel]) -> ())
//}
//
//
//class GroupServiceProxy: GroupServiceInterface {
//
//    let groupService: GroupsAPI
//
//    init(groupService: GroupsAPI ) {
//        self.groupService = groupService
//    }
//
//    func getGroups(completion: @escaping([GroupsModel]) -> ()) {
//        return groupService.getGroups { group in
//            print("🤞\(group)")
//            self.groupService.getGroups(completion: completion)
//        }
//    }
//
//}
