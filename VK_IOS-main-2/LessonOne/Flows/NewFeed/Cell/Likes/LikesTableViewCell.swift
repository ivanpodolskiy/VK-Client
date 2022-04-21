//
//  LikesTableViewCell.swift
//  LessonOne
//
//  Created by user on 24.11.2021.
//

import UIKit

class LikesTableViewCell: UITableViewCell {
   
    @IBOutlet weak var counterLikes: UILabel!
    @IBOutlet weak var counterComments: UILabel!
    @IBOutlet weak var counterReposts: UILabel!
    @IBOutlet weak var counterViews: UILabel!
    
    func config(numLike: Int, numComments: Int, numReposts: Int, numViews: Int ) {
        self.counterLikes.text = String (numLike)
        self.counterComments.text = String (numComments)
        self.counterReposts.text = String (numReposts)
        if numViews > 10000 {
            let num = numViews / 1000
            self.counterViews.text = String ("\(num)K")
        } else {
            self.counterViews.text = String (numViews)
        }
    }
}
