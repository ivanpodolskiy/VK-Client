//
//  GroupsTableViewController.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import UIKit
//import RealmSwift
import Firebase

class GroupsTableViewController: UITableViewController {
   
    let groupService = GroupsAPI()
    var gorupModel: [GroupsModel] = []
    let ref = Database.database().reference(withPath: "group")
    let authService = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        groupService.getGroups { [weak self] groups in
            guard let self = self else {return}
            self.gorupModel = groups
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gorupModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = gorupModel[indexPath.row]
        let url = URL(string: item.photo100)
        if let data = try? Data(contentsOf: url!) {
            cell.imageView?.image = UIImage(data: data)
            cell.textLabel?.text = item.name
        }
        
        //Сохранение в Fairebase
        let group = GroupsFirebse(name: item.name)
        //        print (group.name)
        let cityContainerRef = self.ref.child(group.name).childByAutoId()
        cityContainerRef.setValue(group.toAnyObject())
        return cell
    }
}
