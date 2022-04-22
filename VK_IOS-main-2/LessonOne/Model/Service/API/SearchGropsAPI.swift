//
//  SearchGropsAPI.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol SearchGroupServiceInterface {
    func getGroupFromRequest(searchRequest: String, completion: @escaping([SearchGropsJSON]) -> ())
}

final class SearchGroupService: SearchGroupServiceInterface {
    let baseUrl = "https://api.vk.com/method"
    let token = Session.shared.token
    let userID = Session.shared.userId
    let version = "5.81"
    
    
    func getGroupFromRequest(searchRequest: String, completion: @escaping([SearchGropsJSON] ) -> ()) {
        let method = "/groups.search"
        let searchRequest = searchRequest
        let parametrs: Parameters = [
            "q":searchRequest,
            "access_token":token,
            "v":version
        ]
        let url = baseUrl + method
        AF.request(url, method: .get, parameters: parametrs).responseJSON { response in
            guard let data = response.data else {return}
            debugPrint(response.data?.prettyJSON)
            do {
                let searchGroupJSON = try JSON(data)["response"]["items"].rawData()
                let searchGroup = try JSONDecoder().decode([SearchGropsJSON].self, from: searchGroupJSON)
                completion(searchGroup)
            } catch {
                print(error)
            }
        }
    }
}

class SearchGroupServiceProxy: SearchGroupServiceInterface {
    let searchGroupService: SearchGroupService
    
    init(searchGroupService: SearchGroupService) {
        self.searchGroupService = searchGroupService
    }
    
    func getGroupFromRequest(searchRequest: String, completion: @escaping ([SearchGropsJSON]) -> ()) {
        self.searchGroupService.getGroupFromRequest(searchRequest: searchRequest, completion: completion)
        print ("called func getGroupsFromRequest with request: \(searchRequest)")
    }
}


