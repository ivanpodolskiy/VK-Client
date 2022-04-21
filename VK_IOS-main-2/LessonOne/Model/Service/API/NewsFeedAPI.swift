//
//  NewsFeedAPI.swift
//  LessonOne
//
//  Created by user on 19.11.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

final class NewsFeedAPI{
    let baseUrl = "https://api.vk.com/method"
    let token = Session.shared.token
    let userID = Session.shared.userId
    let version = "5.81"
    
    func getNewsfeed(startFrom: String? = nil, startTime: Int? = nil, completion: @escaping(NewJSON?) -> ()) {
        let method = "/newsfeed.get"
        var parameters: Parameters = [
            "user_id": userID,
            "access_token": token,
            //wall_photo
            "filters":"post,photo,photo_tag,wall_photo",
            "count": 15,
            "v": version,
            //          "start_from": 0,
            //          "start_time": 0
        ]
        if startTime != nil { parameters["start_time"] = startTime }
        if startFrom != nil { parameters["start_from"] = startFrom }
        
        let url = baseUrl + method
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else { return}
            let decoder = JSONDecoder()
            let json = JSON(data)
            let dispatchGroup = DispatchGroup()
            
            let vkItemJSONArr = json["response"]["items"].arrayValue
            let vkProfilesJSONArr = json["response"]["profiles"].arrayValue
            let vkGroupsJSONArr = json["response"]["groups"].arrayValue
            let nextFrom = json["response"]["next_from"].stringValue
            var vkItemsArray: [Item] = []
            var vkProfilesArray: [Profile] = []
            var vkGroupsArray: [NewGroup] = []
            
            DispatchQueue.global().async(group: dispatchGroup) {
                for (index, items) in vkItemJSONArr.enumerated() {
                    do {
                        let decodetItem = try decoder.decode(Item.self, from: items.rawData())
                        vkItemsArray.append(decodetItem)
                        
                    } catch(let errorDecode) {
                        print ("Item decoding error at index \(index), err: \(errorDecode)")
                    }
                }
            }
            
            DispatchQueue.global().async(group: dispatchGroup) {
                for (index, profiles) in vkProfilesJSONArr.enumerated() {
                    do {
                        let decodetProfiles = try decoder.decode(Profile.self, from: profiles.rawData())
                        vkProfilesArray.append(decodetProfiles)
                    } catch(let errorDecode) {
                        print ("Item decoding error at index \(index), err: \(errorDecode)")
                    }
                }
            }
            
            DispatchQueue.global().async(group: dispatchGroup) {
                for (index, groups) in vkGroupsJSONArr.enumerated() {
                    do {
                        let decodetGroup = try decoder.decode(NewGroup.self, from: groups.rawData())
                        vkGroupsArray.append(decodetGroup)
                    } catch(let errorDecode) {
                        print ("Groups decoding error at index \(index), err: \(errorDecode)")
                        
                    }
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                debugPrint (response.data?.prettyJSON)
                let response = Response(items: vkItemsArray, groups: vkGroupsArray, profiles: vkProfilesArray, nextFrom: nextFrom)
                let feed = NewJSON(response: response)
                completion(feed)
            }
        }
    }
}
