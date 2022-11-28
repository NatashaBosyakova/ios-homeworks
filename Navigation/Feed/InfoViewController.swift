//
//  InfoViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var button: CustomButton = {
        
        let button = CustomButton(
            title: "Show alert",
            backgroundColor: UIColor(named: "ButtonColor")!,
            tapAction: showAlert)

        button.translatesAutoresizingMaskIntoConstraints = false
       
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3
        addSubviews()
        setConstraints()        
    }
    
    private func addSubviews() {
        view.addSubview(button)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showAlert() {
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
