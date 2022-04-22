//
//  FriendsAPI.swift
//  LessonOne
//
//  Created by user on 22.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON


final class FriendsMakeAPIOperation: AsyncOperation {
  var data: Data?
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    var request: DataRequest {
        let baseURL = "https://api.vk.com/method"
        let token = Session.shared.token
        let userID = Session.shared.userId
        let version = "5.81"
        let method = "/friends.get"
        let parameters: Parameters = [
            "user_id": userID,
            "order": "name",
            "fields": "photo_50, photo_100",
            "count": 100,
            "access_token": token,
            "v": version
        ]
        let url = baseURL + method
        return AF.request(url, method: .get, parameters: parameters)
    }
    
    override func main() {
        request.responseData { [weak self] response in
            self?.data = response.data
            self?.state = .finished
            print (Thread.current)
        }
    }
}

final class FriendsParcingOperation: AsyncOperation {
    
    private(set) var friendsList: [FriendsModel]?
    
    override func main() {
        guard let operation = self.dependencies.first as? FriendsMakeAPIOperation,
              let data = operation.data,
              let friendsItems = try? JSONDecoder().decode(FriendsJSON.self, from: data).response.items else { return }
        self.friendsList = friendsItems
        self.state = .finished
        print (Thread.current)
    }
}


final class FriendsDisplayOperations: AsyncOperation {
    
    var friendsViewController: FriendsOperationTableViewController
    
    override func main() {
        guard let parsedFriendsListData = dependencies.first as? FriendsParcingOperation,
              let friendsList = parsedFriendsListData.friendsList else { return }
        self.friendsViewController.friendsTest = friendsList
        friendsViewController.tableView.reloadData()
        self.state = .finished
    }
    
    init(controller: FriendsOperationTableViewController) {
        self.friendsViewController = controller
    }
}

//OLD
//final class FriendsAPI {
//
//    let baseUrl = "https://api.vk.com/method"
//    let token = Session.shared.token
//    let userID = Session.shared.userId
//    let version = "5.81"
//
//    func getFriends(completion: @escaping([FriendsModel]) -> ()) {
//
//        let method = "/friends.get"
//
//        let parameters: Parameters = [
//            "user_id": userID,
//            "order": "name",
//            "fields": "photo_50",
//            "count": 1000,
//            "access_token": token,
//            "v": version
//        ]
//
//        let url = baseUrl + method
//        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
//            guard let data = response.data else { return}
//            debugPrint (response.data?.prettyJSON)
//            do {
//                let friendJSON = try JSON(data)["response"]["items"].rawData()
//
//                let friends = try JSONDecoder().decode([FriendsModel].self, from: friendJSON)
//                completion(friends)
//
//            } catch {
//                print(error)
//            }
//        }
//    }
//}

