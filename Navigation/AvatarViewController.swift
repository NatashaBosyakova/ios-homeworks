//
//  AvatarView.swift
//  Navigation
//
//  Created by Наталья Босякова on 07.10.2022.
//

import Foundation

import UIKit

class AvatarViewController: UIViewController {
    
    public var offset: CGFloat
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.offset = 0
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var avatarWidthConstaint: NSLayoutConstraint?
    
    private var avatarHeightConstaint: NSLayoutConstraint?
    
    private lazy var animateAvatar: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private lazy var animateCloseButton: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "multiply")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.black.withAlphaComponent(0.0)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeWindow))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        return imageView
    }()
    
    private func animate() {
        
        self.avatarWidthConstaint?.constant = self.view.bounds.width
        self.avatarHeightConstaint?.constant = self.view.bounds.width
        
        let animator1 = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.animateAvatar.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            self.animateAvatar.layer.cornerRadius = 0
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
         
        let animator2 = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.animateCloseButton.tintColor = UIColor.black.withAlphaComponent(1)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
        
        animator1.startAnimation(afterDelay: 0.0)
        animator2.startAnimation(afterDelay: 0.5)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
        
    func setupView() {
        
        self.view.addSubview(self.animateCloseButton)
        self.view.addSubview(self.animateAvatar)
        
        self.avatarWidthConstaint = self.animateAvatar.widthAnchor.constraint(equalToConstant: 100)
        self.avatarHeightConstaint = self.animateAvatar.heightAnchor.constraint(equalToConstant: 100)

        NSLayoutConstraint.activate([
            
            self.animateCloseButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12),
            self.animateCloseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12),
            self.animateCloseButton.heightAnchor.constraint(equalToConstant: 20),
            self.animateCloseButton.widthAnchor.constraint(equalToConstant: 20),
            
            self.animateAvatar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: offset),
            self.animateAvatar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.avatarWidthConstaint!,
            self.avatarHeightConstaint!,
            
        ])
        
    }

    @objc func closeWindow() {
        self.dismiss(animated: false)
    }
    
}
