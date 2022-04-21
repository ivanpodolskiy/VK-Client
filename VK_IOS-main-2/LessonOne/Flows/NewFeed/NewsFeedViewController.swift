//
//  NewsFeedTableViewController.swift
//  LessonOne
//
//  Created by user on 19.11.2021.
//

import UIKit

class NewsFeedTableViewController: UITableViewController {
    let newService = NewsFeedAPI()
    var itemArray: [Item] = []
    var groupArray: [NewGroup] = []
    var profileArray: [Profile] = []
    var isLoading = false
    var nextFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        self.registerCell()
        self.newService.getNewsfeed{ [weak self]  news in
            guard let self = self else {return}
            self.itemArray = news!.response.items
            self.groupArray = news!.response.groups
            self.profileArray = news!.response.profiles
            self.nextFrom = news!.response.nextFrom
            self.tableView.reloadData()
            self.setupRefreshCntrol()
        }
    }
    
    // MARK: -  REFRESH NEWS
    // Функция настройки контроллера
    fileprivate func setupRefreshCntrol(){
        // Инициализируем и присваиваем сущность UIRefreshControl
        refreshControl = UIRefreshControl()
        // Настраиваем свойства контрола, как, например,
        // отображаемый им текст
        //refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        // Цвет спиннера
        refreshControl?.tintColor = .blue
        //прикрепляем функцию которая будет вызыватся контролом
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    
    @objc func refreshNews() {
        //начинаем обновление новостей
        self.refreshControl?.beginRefreshing()
        //Определеяем время самой свежей новости
        //Или берем текущее время
        let mostFreshNewsData = self.itemArray.first?.date ?? Int(Date().timeIntervalSince1970)
        
        self.newService.getNewsfeed(startTime: mostFreshNewsData + 1) { [weak self] news in
            guard let self = self else {return}
            
            self.refreshControl?.endRefreshing()
            
            guard let items = news?.response.items else { return }
            guard let groups = news?.response.groups else {return}
            guard let profile = news?.response.profiles else { return }
            
            guard items.count > 0 else {return}
            print("new items: \(items.count)")
            
            self.itemArray = items + self.itemArray
            self.groupArray += groups + self.groupArray
            self.profileArray += profile + self.profileArray
            let indexSet = IndexSet(integersIn: 0..<items.count)
            self.tableView.insertSections(indexSet, with: .fade)
        }
    }
    
    
    
    
    // MARK: - регистрация cell
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
        //
        //LikesBarSection
        let nibLikesBar = UINib(nibName: "LikesTableViewCell", bundle: nil)
        self.tableView.register(nibLikesBar, forCellReuseIdentifier: "LikesTableViewCell")
    }
    
    
    // MARK: - TaableViewCell
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //Url фото для PhotoSection
    //Обновеленный метод принимает массив size определенной фотографии
    func findURL(items: [Size]?) -> String? {
        var url = String()
        guard let items = items else {return url}
        
        for items in items { if items.type == "x" { url = items.url } }
        return url
    }
    
    
    // MARK: - Отображение контент в ячейках
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let source = itemArray[indexPath.section].sourceID
            var name, string: String?
            
            if source < 0  {
                groupArray.forEach {
                    if $0.id == abs(source) {
                        print($0.id)
                        name = $0.name
                        string = $0.photo100
                    }
                }
            } else {
                profileArray.forEach {
                    if $0.id == source {
                        print($0.id)
                        name = $0.firstName + " " + $0.lastName
                        string = $0.photo100
                    }
                }
            }
            print ("Instaling Avtar cell \(indexPath.row)")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorAndTimeNewsTableViewCell", for: indexPath) as! AuthorAndTimeNewsTableViewCell
            print ("Instaling Avtar items \(Thread.current)")
            let data = self.itemArray[indexPath.section].date
            print ("config Avatar \(Thread.current)")
            cell.config(name: name ?? "", imageURL: string ?? "", datePublication: data)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            let textNews = self.itemArray[indexPath.section]
            let finalText = textNews.text
            if finalText!.count < 1 {
                let cell2 = UITableViewCell()
                return cell2
            } else {
                cell.conf(text: finalText!)
                return cell
            }
            
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhotoNewsTableViewCell", for: indexPath) as! PhotoNewsTableViewCell
            guard let imag = findURL(items: itemArray[indexPath.section].attachments[0].photo?.sizes) else { let cell = UITableViewCell()
                cell.backgroundColor = .systemGray6
                return cell
            }
            cell.config(photoModel: imag)
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell", for: indexPath) as! LikesTableViewCell
            let item = self.itemArray[indexPath.section]
            let numLikes = item.likes?.count ?? 0
            let numComments = item.comments?.count ?? 0
            let numReposts = item.reposts?.count ?? 0
            let numView: Int  = item.views.count
            cell.config(numLike: numLikes, numComments: numComments, numReposts: numReposts, numViews: numView)
            return cell
        default:
            print ("")
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        func currentPhotoHeight(_ item: Item) -> CGFloat {
            guard let height = item.attachments[0].photo?.photoNum?.height else { return UITableView.automaticDimension }
            guard let width = item.attachments[0].photo?.photoNum?.width else { return UITableView.automaticDimension }
            let tableWidth = tableView.bounds.width
            let aspectRatio = CGFloat(height) / CGFloat(width)
            let cellHeight = tableWidth * aspectRatio
            return cellHeight
        }
        let currentItem = itemArray[indexPath.section]
        
        switch indexPath.row {
        case 2:
            print("Returning image aspect ratio")
            return currentPhotoHeight(currentItem)
        default:
            return UITableView.automaticDimension
        }
    }
}

extension NewsFeedTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Выбираем максимальный номер секции, которую нужно будет отобразить в ближайшее время
        guard let maxSection = indexPaths.map({ $0.section}).max() else { return }
        if maxSection > itemArray.count - 3, !isLoading {
            isLoading = true
            newService.getNewsfeed(startFrom: nextFrom) { [weak self] news in
                guard let self = self else {return}
                guard let newItems = news?.response.items else { return }
                guard let newGroups = news?.response.groups else {return}
                guard let newProfile = news?.response.profiles else { return }
                let indexSet = IndexSet(integersIn: self.itemArray.count ..< self.itemArray.count + newItems.count)
                self.nextFrom = news?.response.nextFrom ?? ""
                self.itemArray.append(contentsOf: newItems)
                self.groupArray.append(contentsOf: newGroups)
                self.profileArray.append(contentsOf: newProfile)
                print("Inside prefetch closure")
                self.tableView.insertSections(indexSet, with: .fade)
                self.isLoading = false
            }
        }
    }
}
