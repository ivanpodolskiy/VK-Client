//
//  PhotoTableViewController.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import UIKit
import RealmSwift

class PhotoTableViewController: UITableViewController {
    let photoService = PhotoAPI()
    var photoDB = PhotoDB()
//    var photoModel: Results<PhotoModel>?
    var token: NotificationToken?
    var photoModel: [PhotoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        photoService.getPhoto { [weak self] photo in
            guard let self = self else { return }
            self.photoModel = photo
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let itemFriends = self.photoModel[indexPath.row]
        let size = itemFriends.sizes[9]
        let url = URL(string: size.url)
        if let data = try? Data(contentsOf: url!) {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
}
