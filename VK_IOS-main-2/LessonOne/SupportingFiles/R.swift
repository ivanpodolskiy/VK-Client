//
//  R.swift
//  LessonOne
//
//  Created by user on 17.09.2021.
//

import UIKit

enum R {
    enum cell {
        static let friendsCell: String = "FirendsCell"
    }
    enum Nib {
        static let friendsNib: UINib = .init(nibName: "FirendsTableViewCell", bundle: nil)
    }
}
