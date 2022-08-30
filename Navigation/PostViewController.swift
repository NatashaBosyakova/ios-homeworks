//
//  PostViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.post = Post(text: "")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray5
        title = post.text
        
        self.navigationController?.navigationBar.tintColor = .black
   }

}
