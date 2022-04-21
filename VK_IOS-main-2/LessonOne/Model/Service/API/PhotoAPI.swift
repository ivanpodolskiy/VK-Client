//
//  PhotoAPI.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

final class PhotoAPI{
    let baseUrl = "https://api.vk.com/method"
    let token = Session.shared.token
    let userID = Session.shared.userId
    let version = "5.81"
    
    
    func getPhoto(completion: @escaping([PhotoModel]) -> ()) {
        let method = "/photos.getAll"
        
        let parametrs: Parameters = [
            "owner_id": 307096492,
            "access_token":token,
            "v":version,
            "no_service_albums": 0,
            "count": 3,
            "extended":1,
            "skip_hidden" : 1
        ]
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parametrs).responseJSON { response in
            guard let data = response.data else {return}
            debugPrint(response.data?.prettyJSON)
            do {
                let photoJSON = try JSON(data)["response"]["items"].rawData()
                let photo = try JSONDecoder().decode([PhotoModel].self, from: photoJSON)
                completion(photo)
            } catch {
                print (error)
            }
        }
    }
}
