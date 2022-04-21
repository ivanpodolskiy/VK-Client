//
//  FriendsOperationTableViewController.swift
//  LessonOne
//
//  Created by user on 14.12.2021.
//

import UIKit
import Alamofire

class FriendsOperationTableViewController: UITableViewController {
    
    var friendsTest: [FriendsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsTest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let itemFriends = friendsTest[indexPath.row]
        let url = URL(string: itemFriends.photo50)
        if let data = try? Data(contentsOf: url!) {
            cell.imageView?.image = UIImage(data: data)
        }
        cell.textLabel?.text = itemFriends.fullName
        return cell
    }
    
    func getFriends() {
        let friendsQueue = OperationQueue()
        let friendsMakeAPIOperation  = FriendsMakeAPIOperation()
        let friendsParsingOperation = FriendsParcingOperation()
        let friendsDisplayOperation =  FriendsDisplayOperations(controller: self)
        friendsQueue.addOperation(friendsMakeAPIOperation)
        friendsParsingOperation.addDependency(friendsMakeAPIOperation)
        friendsQueue.addOperation(friendsParsingOperation)
        friendsDisplayOperation.addDependency(friendsParsingOperation)
        OperationQueue.main.addOperation(friendsDisplayOperation)
    }
}
