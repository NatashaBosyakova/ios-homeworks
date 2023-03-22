//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit
import StorageService
import FirebaseAuth

class FavoritesViewController: UIViewController {
    
    //private var posts: [Post] = [Post(index: 0), Post(index: 1), Post(index: 2), Post(index: 3)]
    private var posts: [Post2] = CoreDataManager().getPosts()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }

    private func setupView() {
        
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? ProfileHeaderView else { return nil }
            headerView.heightAnchor.constraint(equalToConstant: 230).isActive = true
            headerView.clipsToBounds = true
            
            // привяжем обработку нажатия
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showAvatarViewController))
            headerView.imageView.isUserInteractionEnabled = true
            headerView.imageView.addGestureRecognizer(tapGestureRecognizer)
            
            headerView.setUserData(user: self.user!)
            
            return headerView
        }
        
        return nil
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell
        let post = self.posts[indexPath.row - 1]
        
        let isFavorite = true
        
        cell!.addToFavoriteButton.isHidden = isFavorite
        cell!.deleteFromFavoriteButton.isHidden = !isFavorite
        
        cell!.setup(post: post)
        cell!.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return cell!
    }

}


