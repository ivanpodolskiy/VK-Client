//
//  SearchGroupsTableViewController.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import UIKit

class SearchGroupsTableViewController: UITableViewController {
    
    let searchGropsService = SearchGropsAPI()
    var searchGroups: [SearchGropsJSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        searchGropsService.searchGroups { group in
            print ("получили группы из поиска в контроллере")
            self.searchGroups = group
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let itmeSeachGroups = searchGroups[indexPath.row]
        let url = URL(string: itmeSeachGroups.photo50)
        if let data = try? Data(contentsOf: url!) {
            cell.imageView?.image = UIImage(data: data)
        }
        cell.textLabel?.text = itmeSeachGroups.name
        return cell
    }
}
