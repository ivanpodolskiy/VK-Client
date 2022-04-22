//
//  SearchGroupsTableViewController.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import UIKit

class SearchGroupsTableViewController: UITableViewController {
    
    let searchGropsService = SearchGroupService()
    var searchGroups: [SearchGropsJSON] = []
    
   
    
    @IBOutlet weak var serchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.serchBar.delegate = self
    }
    
    func preformsSarchRequest(searchText: String) {
        if searchText != "" {
            let searchGropServiceProxy = SearchGroupServiceProxy(searchGroupService: searchGropsService)
            searchGropServiceProxy.getGroupFromRequest(searchRequest: searchText) { group in
                    self.searchGroups = group
                    self.tableView.reloadData()
            }
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

extension SearchGroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.preformsSarchRequest(searchText: searchText)
    }
}
