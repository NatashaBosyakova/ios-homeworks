//
//  InfoViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var button: UIButton = {
        
        var filled = UIButton.Configuration.filled()
        filled.baseBackgroundColor = .systemGray
        filled.titlePadding = 8
        filled.title = "Show alert"
        filled.cornerStyle = .medium
        
        let button = UIButton(configuration: filled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc func showAlert(sender: UIButton!) {
        let alert = UIAlertController(title: "Alert", message: "just for test",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
           print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            print("OK")
        }))
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
        
    }

}
