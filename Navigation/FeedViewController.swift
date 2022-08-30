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
    
    private lazy var button1: UIButton = {
        
        var filled = UIButton.Configuration.filled()
        filled.baseBackgroundColor = UIColor(named: "ButtonColor")
        filled.titlePadding = 8
        filled.title = "Show post 1"
        filled.cornerStyle = .medium
        
        let button = UIButton(configuration: filled)
        button.addTarget(self, action: #selector(showPostViewController), for: .touchUpInside)

        return button
    }()
 
    private lazy var button2: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.baseBackgroundColor = UIColor(named: "ButtonColor")
        filled.titlePadding = 8
        filled.title = "Show post 2"
        filled.cornerStyle = .medium
        
        let button = UIButton(configuration: filled)
        button.addTarget(self, action: #selector(showPostViewController), for: .touchUpInside)

        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing

        return stackView
    }()
    
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

        addSubviews()
        setConstraints()        
    }
    
    private func addSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoViewController))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        view.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
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
