//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit
import StorageService
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    /*
    private var posts: [Post] = [Post(index: 0), Post(index: 1), Post(index: 2), Post(index: 3)] {
        didSet {
            likesUpdateNeeded = true
        }
    }
     */
    
    private var posts: [Post2] = CoreDataManager().getPosts()
    
    var likesUpdateNeeded: Bool = false
    
    var timerUpdate: Timer! = nil
    
    var timerAddLikes: Timer! = nil
    
    var user: FirebaseAuth.User?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.user = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        // iosint-10 / Домашнее задание к занятию "Run Loop, таймеры"
        // наше приложение многопользовательское
        // другие пользователи оставляют лайки под фотографиями
        // в профиле по таймеру будем обновляем вью для отражения нового количества лайков
        
        /*
        timerUpdate = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            if self.likesUpdateNeeded {
                self.likesUpdateNeeded = false
                let indexPaths = self.tableView.visibleCells.map { self.tableView.indexPath(for: $0) }.compactMap { $0 }
                self.tableView.reloadRows(at: indexPaths, with: .automatic)
            }
        }
                
        // добавляем лайков
        timerAddLikes = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(Int.random(in: 1...15)), execute: {
                if (self.posts.count > 0) {
                    for index in 0...self.posts.count-1 {
                        let newLikes = Int.random(in: 1...10)
                        self.posts[index].likes = self.posts[index].likes + Int16(newLikes)
                        self.posts[index].views = self.posts[index].views + Int16(Int.random(in: newLikes...100))
                    }
                }
            })
        }
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerUpdate.invalidate()
        timerAddLikes.invalidate()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as? PhotosTableViewCell
            cell!.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell!
         }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell
            let post = self.posts[indexPath.row - 1]
            
            print("indexPath.row: \(indexPath.row)")
            print("count: \(self.posts.count)")
            print("post.author 0: \(String(describing: self.posts[0].author))")
            print("post.author 1: \(String(describing: self.posts[1].author))")
            print("post.author 2: \(String(describing: self.posts[2].author))")
            print("post.author 3: \(String(describing: self.posts[3].author))")

            let isFavorite = true
            
            cell!.addToFavoriteButton.isHidden = isFavorite
            cell!.deleteFromFavoriteButton.isHidden = !isFavorite
            
            cell!.setup(post: post)
            cell!.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let controller = PhotosViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @objc func showAvatarViewController() {
        let controller = AvatarViewController()
        controller.offset = -self.tableView.contentOffset.y + 16
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: false)
    }

}


