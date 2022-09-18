//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileHeaderView: ProfileHeaderView = {
        let profileHeaderView = ProfileHeaderView()
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false

        return profileHeaderView
    }()

    private lazy var newButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.setTitle("New button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
 
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray2
                                
        addSubviews()
        addConstraints()        
    }
    
    private func addSubviews() {
        view.addSubview(self.profileHeaderView)
        view.addSubview(self.newButton)
    }
 
    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            profileHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 216),

            newButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            newButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            newButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            newButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            //self.profileHeaderView.resizeView() // after rotating
        }
        
    }

}
