//
//  TestNewsFeedViewController.swift
//  LessonOne
//
//  Created by user on 23.12.2021.
//

import UIKit

class TestNewsFeedViewController: UITableViewController {

    let newService = NewsFeedAPI()
    var newFeedModel: NewJSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCell()
        newService.getNewsfeed{ [weak self]  news in
            guard let self = self else {return}
            
            self.newFeedModel = news
            self.tableView.reloadData()
        }
    }
    
    func registerCell(){
        
        //AuthorSection
        let nibAuthor = UINib(nibName: "AuthorAndTimeNewsTableViewCell", bundle: nil)
        self.tableView.register(nibAuthor, forCellReuseIdentifier: "AuthorAndTimeNewsTableViewCell")
        
        //TextSection
        let nibText = UINib(nibName: "TextTableViewCell", bundle: nil)
        self.tableView.register(nibText, forCellReuseIdentifier: "TextTableViewCell")
        
        //PhotoSection
        let nibPhoto = UINib(nibName: "PhotoNewsTableViewCell", bundle: nil)
        self.tableView.register(nibPhoto, forCellReuseIdentifier: "PhotoNewsTableViewCell")
        
        //LikesBarSection
        let nibLikesBar = UINib(nibName: "LikesTableViewCell", bundle: nil)
        self.tableView.register(nibLikesBar, forCellReuseIdentifier: "LikesTableViewCell")
        
        
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = newFeedModel else { return 0 }
        return sections.response.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        guard let sections = newFeedModel else { return 0 }
        return 4
        
    }
    
    //Обновеленный метод принимает массив size определенной фотографии
    func findURL2(items: [Size]?) -> String? {
        DispatchQueue.global(priority: .background).sync {
            var url = String()
            guard let items = items else {return url}
            //            for items in items {
            for items in items {
                if items.type == "x" {
                    url = items.url
                }
            }
            
            
            return url
        }
        
    }
    
    
    
    //основной метод
    func test(Test: IndexPath, cell1: AuthorAndTimeNewsTableViewCell, cell2: TextTableViewCell, cell3: PhotoNewsTableViewCell, cell4: LikesTableViewCell) -> UITableViewCell {
        var DispatchTest = DispatchQueue(label: "testDispatch")
   
        
        
        guard let profiles = newFeedModel?.response.profiles,
              let groups = newFeedModel?.response.groups,
              let items = newFeedModel?.response.items else { return UITableViewCell() }
        
        let source = items[Test.section].sourceID
        
        
        
        var name, string: String?
        DispatchTest.sync() {
            if source < 0  {
                
                print  ("Искали данные \(Thread.current)")
                groups.forEach {
                    if $0.id == abs(source) {
                        print($0.id)
                        name = $0.name
                        string = $0.photo100
                        
                    } else {
                        profiles.forEach {
                            if $0.id == source {
                                print($0.id)
                                name = $0.firstName + " " + $0.lastName
                                string = $0.photo100
                            }
                        }
                    }
                }
            }
        }
        
        
        
        
        switch (Test.section) {
            
            
            
        default:
            
            switch Test.row {
            case 0:
                
                
                print ("Instaling Avtar cell \(Test.row)")
                
                
                //изменил тут self.newFeedModel?.response.groups[Test.section] -> self.newFeedModel?.response.groups[Test.row]
                let avtarNews = self.newFeedModel?.response.groups[Test.row]
                let data = self.newFeedModel?.response.items[Test.section].date ?? 0
                
                
                let url = avtarNews?.photo100 ?? ""
                
                cell1.config(name: name ?? "", image: string ?? "", datePublication: data)
                return cell1
                
                
            case 1:
                print ("Instaling text cell")
                
                
                let textNews = self.newFeedModel?.response.items[Test.section]
                if let tex = textNews?.text {
                    cell2.conf(text: tex)
                } else {
                    print ("error index")
                }
                
                return cell2
                
            case 2:
                print ("Instaling photo cell")
                
                //Теперь указываю полный путь до фото attachments[0].photo?.sizes, было -  items[Test.section].attachments
                guard let imag = findURL2(items: items[Test.section].attachments[0].photo?.sizes) else { let cell = UITableViewCell()
                    cell.backgroundColor = .systemGray6
                    return cell
                }
                
                
                cell3.config(photoModel: imag)
                return cell3
                
            case 3:
                print ("Instaling likesBar cell")
                
                
                let item = self.newFeedModel?.response.items[Test.section]
                let numLikes = item?.likes?.count ?? 0
                let numComments = item?.comments?.count ?? 0
                let numReposts = item?.reposts?.count ?? 0
                let numView: Int  = item?.views.count ?? 0
                
                cell4.config(numLike: numLikes, numComments: numComments, numReposts: numReposts, numViews: numView)
                
                
                return cell4
                
                
            default:
                print ("There is no data \(Test.row)")
                //                                let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorAndTimeNewsTableViewCell", for: indexPath) as! AuthorAndTimeNewsTableViewCell
                tableView.tableFooterView = nil
                
                return cell1
                
            }
            
        }
    }
    
    
    
    // }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "AuthorAndTimeNewsTableViewCell", for: indexPath) as! AuthorAndTimeNewsTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
        let cell3 = self.tableView.dequeueReusableCell(withIdentifier: "PhotoNewsTableViewCell", for: indexPath) as! PhotoNewsTableViewCell
        let cell4 = self.tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell", for: indexPath) as! LikesTableViewCell
        
        return test(Test: indexPath, cell1: cell1, cell2: cell2, cell3: cell3, cell4: cell4)
        
    }
}
