//
//  AuthorAndTimeNewsTableViewCell.swift
//  LessonOne
//
//  Created by user on 24.11.2021.
//

import UIKit

class AuthorAndTimeNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var LastSeenLabel: UILabel!
    
    func config(name: String, imageURL: String, datePublication: Int) {
        self.nameLable.text = name
        //Фото профиля
        if let url = URL(string: imageURL) {
            let data = try? Data(contentsOf: url)
            self.avatarView.image = UIImage(data: data!)
        }
        //Дата
        let dateformatter = DateFormatter()
        let dateInt = Double(datePublication)
        
        let date = Date(timeIntervalSince1970: dateInt)
        dateformatter.dateStyle = .medium
        self.LastSeenLabel.text = dateformatter.string(from: date)
        print("Publication date is \(date)")
    }
    
    override func layoutSubviews() {
            self.avatarView.layer.borderWidth = 0
            self.avatarView.layer.masksToBounds = true
            self.avatarView.layer.borderColor = UIColor.black.cgColor
            self.avatarView.layer.cornerRadius = 50/2
            self.avatarView.clipsToBounds = true
    }
}
