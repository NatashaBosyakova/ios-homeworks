//
//  LogInViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 18.09.2022.
//

import UIKit

class LogInViewController: UIViewController {
    
    public var tabBarHeight: CGFloat = {return CGFloat(0)}()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var imageViewCenter: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private lazy var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.layer.cornerRadius = 10.0
        stackView.layer.borderWidth = 0.5
        stackView.clipsToBounds = true
        stackView.spacing = -1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    private lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
   
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.tag = 0
        textField.placeholder = "Login"
        textField.textColor = .black
        textField.autocapitalizationType = .none
        
        textField.clearButtonMode = .whileEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.tag = 1
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.autocapitalizationType = .none

        textField.isSecureTextEntry = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showProfileViewController), for: .touchUpInside)
        return button
    }()
    
    private var login: String?

    override func viewDidLoad() {
                
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = .white
        self.setupGestures()
        
        self.stackView.addArrangedSubview(self.loginTextField)
        self.stackView.addArrangedSubview(self.passwordTextField)

        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.imageViewCenter)
        self.scrollView.addSubview(self.stackView)
        self.scrollView.addSubview(self.button)
        
        let scrollViewConstraints = self.scrollViewConstraints()
        let stackViewConstraints = self.stackViewConstraints()
        NSLayoutConstraint.activate(
            scrollViewConstraints
            + stackViewConstraints
        )
   }
    
    private func scrollViewConstraints() -> [NSLayoutConstraint] {
        
        return [
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            //self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.tabBarHeight),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
       ]
    }
    
    private func stackViewConstraints() -> [NSLayoutConstraint] {
        
        return [
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 340),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.stackView.heightAnchor.constraint(equalToConstant: 100),

            self.button.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 16),
            self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.button.heightAnchor.constraint(equalToConstant: 50),
            
            self.imageViewCenter.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageViewCenter.bottomAnchor.constraint(equalTo: self.stackView.topAnchor),

            self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.imageViewCenter.centerYAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
        
        ]
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonBottomPointY = self.button.frame.origin.y + self.button.frame.height
            let keyboardOriginY = self.view.frame.height -
                keyboardHeight -
                self.view.safeAreaInsets.top
            
            let yOffset = keyboardOriginY < loginButtonBottomPointY
            ? loginButtonBottomPointY - keyboardOriginY + 16
            : 0
            
            self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset - self.view.safeAreaInsets.top), animated: true)
       }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.view.safeAreaInsets.top), animated: true)
    }
    
    @objc func showProfileViewController(sender: UIButton!) {
        let controller = ProfileViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.forcedHidingKeyboard()
        return true
    }
}
