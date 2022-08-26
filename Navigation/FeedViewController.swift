//
//  FeedViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

struct Post {
    var text: String
}

class FeedViewController: UIViewController {
    
    var post: Post
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.post = Post(text: "Some post (title from FeedViewController)")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .systemGray3
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0 )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show post", for: .normal)
        button.addTarget(self, action: #selector(showPostViewController), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoViewController))
        navigationItem.rightBarButtonItem?.tintColor = .white

    }
    
    @objc func showPostViewController(sender: UIButton!) {
        let controller = PostViewController()
        controller.post = self.post
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func showInfoViewController(sender: UIButton!) {
        let controller = InfoViewController()
        controller.modalPresentationStyle = .popover
        self.present(controller, animated: true)
    }

}
