//
//  PromiseGroupsTableViewController.swift
//  LessonOne
//
//  Created by user on 21.12.2021.
//

import UIKit
import PromiseKit

class PromiseGroupsTableViewController: UITableViewController {
    let groupService = GroupsAPI()
    var groupsModel: [GroupsModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        getGroups()
    }
    
    func getGroups() {
        firstly {
            self.groupService.promiseGetGroup()
        }.ensure {

        }.done { groups in
            self.groupsModel = groups
            print (groups)
            self.tableView.reloadData()
        }.catch { error in
            print (error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let itemGroup = groupsModel[indexPath.row]
        cell.textLabel?.text = itemGroup.name
        let url = URL(string: itemGroup.photo100 )
        if let data = try? Data(contentsOf: url!) {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
}
